/** Main application logic. */
let featureCache = [];
let currentFeatureText = "";
let currentFeaturePath = "<inline>";
let scenarioCache = [];
let selectedArtifactIds = new Set();

const DIAGRAM_NAMES = {
  usecase: "Use Case Diagram",
  sequence: "Sequence Diagram",
  class: "Class Diagram",
  activity: "Activity Diagram",
  state: "State Diagram",
};

async function initializeApp() {
  await loadFeatures();
  await loadArtifacts();
}

async function loadFeatures() {
  const select = document.getElementById("featureSelect");
  try {
    featureCache = await fetchFeatures();
    select.innerHTML = '<option value="">Select a feature...</option>';
    for (const feature of featureCache) {
      const option = document.createElement("option");
      option.value = feature.path;
      option.textContent = feature.name;
      select.appendChild(option);
    }
  } catch (error) {
    select.innerHTML = '<option value="">Features unavailable</option>';
    showToast(error.message);
  }
}

async function onFeatureChange() {
  const path = document.getElementById("featureSelect").value;
  const scenarioSelect = document.getElementById("scenarioSelect");
  const loadFeatureBtn = document.getElementById("loadFeatureBtn");
  const info = document.getElementById("selectedInfo");
  currentFeatureText = "";
  currentFeaturePath = path || "<inline>";
  scenarioCache = [];
  scenarioSelect.disabled = true;
  loadFeatureBtn.disabled = true;
  document.getElementById("loadScenarioBtn").disabled = true;
  if (!path) {
    scenarioSelect.innerHTML = '<option value="">Select a feature first</option>';
    info.textContent = "No selection made.";
    return;
  }

  showLoading(true);
  try {
    currentFeatureText = await fetchFeatureContent(path);
    scenarioCache = await parseScenarios(currentFeatureText, path);
    scenarioSelect.innerHTML = '<option value="">Select a scenario...</option>';
    scenarioCache.forEach((scenario, index) => {
      const option = document.createElement("option");
      option.value = String(index);
      option.textContent = scenario.title;
      scenarioSelect.appendChild(option);
    });
    scenarioSelect.disabled = scenarioCache.length === 0;
    loadFeatureBtn.disabled = false;
    info.textContent = `${path}: ${scenarioCache.length} scenario/use-case block(s)`;
  } catch (error) {
    showToast(error.message);
  } finally {
    showLoading(false);
  }
}

function onScenarioChange() {
  const index = document.getElementById("scenarioSelect").value;
  const scenario = index === "" ? null : scenarioCache[Number(index)];
  document.getElementById("loadScenarioBtn").disabled = !scenario;
  document.getElementById("selectedInfo").textContent = scenario
    ? `Scenario selected: ${scenario.title}`
    : "Scenario was not selected.";
}

function loadSelectedScenarioToEditor() {
  const index = document.getElementById("scenarioSelect").value;
  const scenario = index === "" ? null : scenarioCache[Number(index)];
  if (!scenario) return showToast("Choose a scenario first.");
  document.getElementById("bddInput").value = scenario.blockText;
  currentFeaturePath = scenario.source?.file || currentFeaturePath;
  showToast("Scenario loaded.");
}

function loadWholeFeatureToEditor() {
  if (!currentFeatureText.trim()) return showToast("Select a feature first.");
  document.getElementById("bddInput").value = currentFeatureText;
  showToast("Feature loaded.");
}

function inputText() {
  return document.getElementById("bddInput").value.trim();
}

async function runGeneration(fn, tabName, successMessage) {
  const input = inputText();
  if (!input) return showToast("Please enter a BDD scenario.");
  showLoading(true);
  try {
    const data = await fn(input, currentFeaturePath);
    displayOutput(`${tabName}-output`, data.result);
    switchTab(tabName);
    const cacheNote = data.from_cache ? " (cache)" : "";
    showToast(`${successMessage}${cacheNote}`);
    await loadArtifacts();
  } catch (error) {
    showToast(error.message, 6000);
  } finally {
    showLoading(false);
  }
}

async function handleGenerateRequirements() {
  return runGeneration(generateRequirements, "requirements", "Requirements generated");
}

async function handleGenerateTestCases() {
  return runGeneration(generateTestCases, "testcases", "Test cases generated");
}

async function handleGenerateUMLDiagram(type) {
  closeUMLDialog();
  const input = inputText();
  if (!input) return showToast("Please enter a BDD scenario.");
  showLoading(true);
  try {
    const data = await generateUML(input, DIAGRAM_NAMES[type] || DIAGRAM_NAMES.sequence, currentFeaturePath);
    displayOutput("uml-output", data.result);
    switchTab("uml");
    showToast(`UML generated${data.from_cache ? " (cache)" : ""}`);
    await loadArtifacts();
  } catch (error) {
    showToast(error.message, 6000);
  } finally {
    showLoading(false);
  }
}

async function loadArtifacts() {
  const container = document.getElementById("artifactList");
  if (!container) return;
  const type = document.getElementById("artifactTypeFilter")?.value || "";
  try {
    const artifacts = await fetchArtifacts(type);
    if (!artifacts.length) {
      container.innerHTML = '<p class="placeholder-hint">No generated artifacts yet.</p>';
      return;
    }
    container.innerHTML = "";
    for (const artifact of artifacts) {
      const row = document.createElement("div");
      row.className = "artifact-row";
      row.innerHTML = `
        <label class="artifact-select"><input type="checkbox" data-artifact-id="${artifact.id}"></label>
        <div class="artifact-main">
          <strong>${escapeHtml(artifact.output_type)} — ${escapeHtml(artifact.id.slice(0, 8))}</strong>
          <small>${escapeHtml(artifact.created_at)} · ${escapeHtml(artifact.provider)}/${escapeHtml(artifact.model)} · ${escapeHtml(artifact.status)}</small>
        </div>
        <div class="artifact-actions">
          <button data-action="open">Open</button>
          <button data-action="json">JSON</button>
          <button data-action="md">Markdown</button>
          <button data-action="csv">CSV</button>
          <button data-action="docx">Word</button>
          <button data-action="xlsx">Excel</button>
          <button data-action="reqif">ReqIF</button>
          <button data-action="approve">Approve</button>
          <button data-action="regenerate">Regenerate</button>
        </div>`;
      row.querySelector("input").addEventListener("change", (event) => {
        if (event.target.checked) selectedArtifactIds.add(artifact.id);
        else selectedArtifactIds.delete(artifact.id);
      });
      row.querySelector('[data-action="open"]').onclick = async () => {
        const full = await fetchArtifact(artifact.id);
        displayOutput(`${full.output_type === "requirements" ? "requirements" : full.output_type}-output`, full.content);
        switchTab(full.output_type === "requirements" ? "requirements" : full.output_type);
      };
      for (const format of ["json", "md", "csv", "docx", "xlsx", "reqif"]) {
        row.querySelector(`[data-action="${format}"]`).onclick = () =>
          downloadArtifactExport(artifact.id, format).catch((error) => showToast(error.message));
      }
      row.querySelector('[data-action="approve"]').onclick = async () => {
        await reviewArtifact(artifact.id, "approved", "Approved in web review workflow");
        await loadArtifacts();
      };
      row.querySelector('[data-action="regenerate"]').onclick = async () => {
        showLoading(true);
        try {
          await regenerateArtifact(artifact.id);
          await loadArtifacts();
          showToast("Artifact regenerated.");
        } catch (error) {
          showToast(error.message);
        } finally {
          showLoading(false);
        }
      };
      container.appendChild(row);
    }
  } catch (error) {
    container.textContent = error.message;
  }
}

async function compareSelectedArtifacts() {
  const ids = Array.from(selectedArtifactIds);
  if (ids.length !== 2) return showToast("Select exactly two artifacts.");
  try {
    const data = await compareArtifacts(ids[0], ids[1]);
    displayOutput("comparison-output", data.comparison.diff || "Artifacts are identical.");
  } catch (error) {
    showToast(error.message);
  }
}
async function handleTranslateOutput(tabName) {
  const outputEl = document.getElementById(`${tabName}-output`);
  const text = outputEl?.innerText.trim();
  if (!text) return showToast("Once bir cikti uretmelisiniz.");

  const langSelect = document.getElementById(`${tabName}-lang`);
  const targetLanguage = langSelect?.value || "Turkish";

  showLoading(true);
  try {
    const data = await translateText(text, targetLanguage);
    displayOutput(`${tabName}-output`, data.result);
    showToast(`${targetLanguage} ceviri tamamlandi${data.from_cache ? " (cache)" : ""}`);
  } catch (error) {
    showToast(error.message, 6000);
  } finally {
    showLoading(false);
  }
}

document.addEventListener("DOMContentLoaded", initializeApp);

function saveApiKey() {
  const value = document.getElementById("apiKeyInput")?.value.trim() || "";
  if (value) window.localStorage.setItem("bdd_api_key", value);
  else window.localStorage.removeItem("bdd_api_key");
  showToast(value ? "API key saved in this browser." : "API key removed.");
}
