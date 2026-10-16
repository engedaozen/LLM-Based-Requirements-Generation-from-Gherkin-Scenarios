/**
 * UI Helpers
 * DOM manipulasyonu ve UI yardimci fonksiyonlari
 */

/**
 * Loading overlay'i goster/gizle
 * @param {boolean} show
 */
function showLoading(show) {
  const overlay = document.getElementById("loadingOverlay");
  if (overlay) {
    overlay.classList.toggle("hidden", !show);
  }
}

/**
 * Toast mesaji goster
 * @param {string} message
 * @param {number} duration - ms cinsinden sure (default 3000)
 */
function showToast(message, duration = 3000) {
  const toast = document.getElementById("toast");
  if (!toast) return;
  
  toast.textContent = message;
  toast.classList.remove("hidden");
  
  setTimeout(() => {
    toast.classList.add("hidden");
  }, duration);
}

/**
 * Tab degistir
 * @param {string} tabName - requirements, testcases, uml
 */
function switchTab(tabName) {
  // Tum tab icerikleri gizle
  document.querySelectorAll(".tab-content").forEach((tab) => {
    tab.classList.remove("active");
  });
  
  // Tum tab butonlarini deaktif et
  document.querySelectorAll(".tab-btn").forEach((btn) => {
    btn.classList.remove("active");
  });
  
  // Secili tab'i aktif et
  const tabContent = document.getElementById(`${tabName}-tab`);
  if (tabContent) {
    tabContent.classList.add("active");
  }
  
  // Secili butonu aktif et
  const tabBtn = document.querySelector(`.tab-btn[onclick*="${tabName}"]`);
  if (tabBtn) {
    tabBtn.classList.add("active");
  }
}

/**
 * Output icerigi goster
 * @param {string} containerId - Container element ID
 * @param {string} content - Gosterilecek icerik
 */
function displayOutput(containerId, content) {
  const container = document.getElementById(containerId);
  if (container) {
    container.innerHTML = `<pre>${escapeHtml(content)}</pre>`;
  }
}

/**
 * Ciktiyi panoya kopyala
 * @param {string} tabName - Tab adi
 */
function copyOutput(tabName) {
  const outputEl = document.getElementById(`${tabName}-output`);
  if (!outputEl) return;
  
  const outputText = outputEl.innerText;
  
  if (!outputText || outputText.includes("will appear")) {
    showToast("There's no content to copy yet!");
    return;
  }
  
  navigator.clipboard
    .writeText(outputText)
    .then(() => showToast("Copied to clipboard!"))
    .catch(() => showToast("Copying failed!"));
}

/**
 * Ciktiyi dosya olarak indir
 * @param {string} tabName - Tab adi
 * @param {string} extension - Dosya uzantisi (default: txt)
 */
function downloadOutput(tabName, extension = "txt") {
  const outputEl = document.getElementById(`${tabName}-output`);
  if (!outputEl) return;
  
  const outputText = outputEl.innerText;
  
  if (!outputText || outputText.includes("will appear")) {
    showToast("There's no content to download yet!");
    return;
  }
  
  const blob = new Blob([outputText], { type: "text/plain;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `${tabName}_${Date.now()}.${extension}`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  
  showToast("File downloaded!");
}

/**
 * UML diyagramini indir
 */
function downloadDiagram() {
  const outputEl = document.getElementById("uml-output");
  if (!outputEl) return;
  
  const text = outputEl.innerText.trim();
  
  if (!text || text.includes("will appear")) {
    showToast("There are no diagrams available to download yet!");
    return;
  }
  
  const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `uml_plantuml_${Date.now()}.puml`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
  
  showToast("PlantUML code has been downloaded!");
}

/**
 * UML dialog'u goster
 */
function showUMLDialog() {
  const input = document.getElementById("bddInput");
  if (!input || !input.value.trim()) {
    showToast("Please enter a BDD scenario!");
    return;
  }
  
  const dialog = document.getElementById("umlDialog");
  if (dialog) {
    dialog.classList.remove("hidden");
  }
}

/**
 * UML dialog'u kapat
 */
function closeUMLDialog() {
  const dialog = document.getElementById("umlDialog");
  if (dialog) {
    dialog.classList.add("hidden");
  }
}

/**
 * BDD input'u temizle
 */
function clearInput() {
  const input = document.getElementById("bddInput");
  if (input) {
    input.value = "";
  }
  showToast("Input cleared.");
}

/**
 * HTML karakterlerini escape et (XSS korumasi)
 * @param {string} str
 * @returns {string}
 */
function escapeHtml(str) {
  return String(str ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

/**
 * Select element'i doldur
 * @param {HTMLSelectElement} selectEl - Select elementi
 * @param {Array<{value: string, label: string}>} options - Secenekler
 * @param {string} placeholder - Placeholder metin
 */
function populateSelect(selectEl, options, placeholder = "Select...") {
  selectEl.innerHTML = `<option value="">${placeholder}</option>`;
  
  for (const opt of options) {
    const optionEl = document.createElement("option");
    optionEl.value = opt.value;
    optionEl.textContent = opt.label;
    selectEl.appendChild(optionEl);
  }
}

// Export for module usage
if (typeof module !== "undefined" && module.exports) {
  module.exports = {
    showLoading,
    showToast,
    switchTab,
    displayOutput,
    copyOutput,
    downloadOutput,
    downloadDiagram,
    showUMLDialog,
    closeUMLDialog,
    clearInput,
    escapeHtml,
    populateSelect,
  };
}
