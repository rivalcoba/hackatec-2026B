const API = '/api';
const DEVICE_ICONS = { fire: '🔥', water: '🌊', presence: '👷', motor: '⚙️' };
const OPTIONS = {
  fire: [['false', '✅ Sin fuego'], ['true', '🔥 Fuego detectado']],
  water: [['normal', '💧 Normal'], ['high', '🌊 Nivel alto']],
  presence: [['present', '👷 Presente'], ['absent', '🚫 Ausente']],
  motor: [['off', '⏹️ Apagado'], ['on', '⚙️ Encendido']],
};
const LABELS = {
  fire: { false: '✅ Sin fuego', true: '🔥 Fuego detectado' },
  water: { normal: '💧 Normal', high: '🌊 Nivel alto' },
  presence: { present: '👷 Presente', absent: '🚫 Ausente' },
  motor: { off: '⏹️ Apagado', on: '⚙️ Encendido' },
};
const CAUSES = { fire_detected: '🔥 Fuego detectado', water_high: '🌊 Nivel de agua alto', motor_on_without_operator: '⚙️ Motor encendido sin operador' };
const grid = document.getElementById('deviceGrid');
const cards = new Map();
const toast = document.getElementById('toast');
let toastTimer;

function showToast(message, error = false) {
  toast.textContent = message;
  toast.className = `toast show${error ? ' error' : ''}`;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { toast.className = 'toast'; }, 3200);
}

function setConnection(connected) {
  const element = document.getElementById('connection');
  element.classList.toggle('connected', connected);
  element.classList.toggle('disconnected', !connected);
  document.getElementById('connectionText').textContent = connected ? 'Canal en vivo conectado' : 'Canal en vivo desconectado; reintentando...';
}

function addCard(device, index) {
  const card = document.createElement('article');
  card.className = 'device-card';
  const head = document.createElement('div');
  head.className = 'device-head';
  const titleGroup = document.createElement('div');
  const number = document.createElement('span');
  number.className = 'device-index';
  number.textContent = `DISPOSITIVO 0${index + 1}`;
  const title = document.createElement('h3');
  const icon = document.createElement('span');
  icon.className = 'device-emoji';
  icon.setAttribute('aria-hidden', 'true');
  icon.textContent = DEVICE_ICONS[device.type] || '📟';
  title.append(icon, document.createTextNode(device.name));
  titleGroup.append(number, title);
  const id = document.createElement('span');
  id.className = 'device-id';
  id.textContent = device.id;
  head.append(titleGroup, id);

  const stateRow = document.createElement('div');
  stateRow.className = 'device-state';
  const stateGroup = document.createElement('div');
  const stateLabel = document.createElement('div');
  stateLabel.className = 'state-label';
  stateLabel.textContent = 'Estado actual';
  const stateValue = document.createElement('strong');
  stateValue.className = 'state-value';
  stateGroup.append(stateLabel, stateValue);
  const updated = document.createElement('span');
  updated.className = 'updated';
  stateRow.append(stateGroup, updated);

  const form = document.createElement('form');
  form.className = 'control-row';
  const select = document.createElement('select');
  select.setAttribute('aria-label', `Nuevo estado: ${device.name}`);
  OPTIONS[device.type].forEach(([value, label]) => {
    const option = document.createElement('option');
    option.value = value;
    option.textContent = label;
    select.append(option);
  });
  const button = document.createElement('button');
  button.type = 'submit';
  button.textContent = '📡 Enviar estado';
  form.append(select, button);
  const elements = { stateValue, updated, select, button, device };
  form.addEventListener('submit', (event) => submitUpdate(event, elements));
  card.append(head, stateRow, form);
  grid.append(card);
  cards.set(device.id, elements);
}

function renderState(state) {
  if (!state || !Array.isArray(state.devices)) return;
  state.devices.forEach((device, index) => {
    if (!cards.has(device.id)) addCard(device, index);
    const elements = cards.get(device.id);
    elements.device = device;
    elements.stateValue.textContent = LABELS[device.type]?.[String(device.value)] || 'Desconocido';
    elements.stateValue.dataset.alert = String((device.type === 'fire' && device.value === true) || (device.type === 'water' && device.value === 'high'));
    elements.updated.textContent = device.updatedAt ? `ACT. ${new Date(device.updatedAt).toLocaleTimeString('es-MX')}` : 'SIN ACTUALIZACIÓN';
    if (document.activeElement !== elements.select) elements.select.value = String(device.value);
  });
  const active = Boolean(state.alarm?.active);
  document.getElementById('alarmBanner').classList.toggle('active', active);
  document.getElementById('alarmSymbol').textContent = active ? '🚨' : '✅';
  document.getElementById('alarmTitle').textContent = active ? 'Alarma activa' : 'Sistema sin alarmas';
  const causes = (state.alarm?.causes || []).map((cause) => CAUSES[cause] || cause);
  document.getElementById('alarmDetails').textContent = causes.length ? causes.join(' · ') : 'Los dispositivos están en estado normal.';
}

async function submitUpdate(event, elements) {
  event.preventDefault();
  const { device, select, button } = elements;
  const value = device.type === 'fire' ? select.value === 'true' : select.value;
  button.disabled = true;
  try {
    const response = await fetch(`${API}/devices/${encodeURIComponent(device.id)}`, {
      method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ value }),
    });
    const state = await response.json();
    if (!response.ok) throw new Error(state.error || 'No se pudo enviar el estado');
    renderState(state);
    showToast(`✅ Estado enviado: ${device.name}`);
  } catch (error) {
    showToast(error.message || 'Error de conexión con el servidor', true);
  } finally {
    button.disabled = false;
  }
}

async function loadState() {
  const response = await fetch(`${API}/devices`);
  if (!response.ok) throw new Error('No se pudo cargar el estado de los dispositivos');
  renderState(await response.json());
}

function connectEvents() {
  const stream = new EventSource(`${API}/events`);
  stream.onopen = () => setConnection(true);
  stream.onerror = () => setConnection(false);
  stream.onmessage = (message) => {
    try { renderState(JSON.parse(message.data).state); } catch (error) { showToast('Actualización no válida', true); }
  };
}

loadState().catch((error) => showToast(error.message, true)).finally(connectEvents);
