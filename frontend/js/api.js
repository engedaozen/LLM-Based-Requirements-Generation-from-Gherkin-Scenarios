/** Same-origin API client. */
const API_BASE_URL = "/api";

function apiHeaders(includeJson = true) {
  const headers = {};
  if (includeJson) headers["Content-Type"] = "application/json";
  const key = window.localStorage.getItem("bdd_api_key");
  if (key) headers["X-API-Key"] = key;
  return headers;
}

async function apiRequest(endpoint, options = {}) {
  const merged = {
    ...options,
    headers: { ...apiHeaders(true), ...(options.headers || {}) },
  };
  const response = await fetch(`${API_BASE_URL}${endpoint}`, merged);
  let data = null;
  try {
    data = await response.json();
  } catch (_error) {
    data = { success: false, error: `HTTP ${response.status}` };
  }
  if (!response.ok || !data.success) {
    const detail = data.validation?.errors?.join("; ");
    throw new Error(detail || data.error || `HTTP ${response.status}`);
  }
  return data;
}

async function fetchFeatures() {
  return (await apiRequest("/features")).features || [];
}

async function fetchFeatureContent(path) {
  return (await apiRequest(`/feature?path=${encodeURIComponent(path)}`)).content || "";
}

async function parseScenarios(text, filename = "<inline>") {
  return (await apiRequest("/parse-scenarios", {
    method: "POST",
    body: JSON.stringify({ text, filename }),
  })).scenarios || [];
}

async function generateRequirements(bddText, sourceFile = "<inline>") {
  return apiRequest("/generate", {
    method: "POST",
    body: JSON.stringify({ text: bddText, type: "requirement", source_file: sourceFile }),
  });
}

async function generateTestCases(bddText, sourceFile = "<inline>") {
  return apiRequest("/generate", {
    method: "POST",
    body: JSON.stringify({ text: bddText, type: "testcase", source_file: sourceFile }),
  });
}

async function generateUML(bddText, diagramType, sourceFile = "<inline>") {
  return apiRequest("/generate", {
    method: "POST",
    body: JSON.stringify({
      text: bddText,
      type: "uml",
      diagram_type: diagramType,
      source_file: sourceFile,
    }),
  });
}

async function fetchArtifacts(type = "") {
  const query = type ? `?type=${encodeURIComponent(type)}` : "";
  return (await apiRequest(`/outputs${query}`)).artifacts || [];
}

async function fetchArtifact(id) {
  return (await apiRequest(`/outputs/${encodeURIComponent(id)}`)).artifact;
}

async function reviewArtifact(id, status, note = "") {
  return apiRequest(`/outputs/${encodeURIComponent(id)}/review`, {
    method: "PATCH",
    body: JSON.stringify({ status, note }),
  });
}

async function regenerateArtifact(id) {
  return apiRequest(`/outputs/${encodeURIComponent(id)}/regenerate`, { method: "POST" });
}

async function compareArtifacts(leftId, rightId) {
  return apiRequest("/outputs/compare", {
    method: "POST",
    body: JSON.stringify({ left_id: leftId, right_id: rightId }),
  });
}

async function translateText(text, targetLanguage = "Turkish") {
  return apiRequest("/translate", {
    method: "POST",
    body: JSON.stringify({ text, target_language: targetLanguage }),
  });
}

async function downloadArtifactExport(id, format) {
  const response = await fetch(
    `${API_BASE_URL}/outputs/${encodeURIComponent(id)}/export/${encodeURIComponent(format)}`,
    { headers: apiHeaders(false) },
  );
  if (!response.ok) {
    let message = `Export failed (HTTP ${response.status})`;
    try {
      const data = await response.json();
      message = data.error || message;
    } catch (_error) {}
    throw new Error(message);
  }
  const blob = await response.blob();
  const disposition = response.headers.get("Content-Disposition") || "";
  const match = disposition.match(/filename\*?=(?:UTF-8'')?["']?([^"';]+)/i);
  const filename = match ? decodeURIComponent(match[1]) : `artifact.${format}`;
  const url = URL.createObjectURL(blob);
  const anchor = document.createElement("a");
  anchor.href = url;
  anchor.download = filename;
  document.body.appendChild(anchor);
  anchor.click();
  anchor.remove();
  URL.revokeObjectURL(url);
}
