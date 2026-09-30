const API = '/api';
const DEVICE_ICONS = { fire: '🔥', water: '🌊', presence: '👷', motor: '⚙️' };
const LABELS = {
  fire: { false: '✅ Sin fuego', true: '🔥 Fuego detectado' }, water: { normal: '💧 Normal', high: '🌊 Nivel alto' },
  presence: { present: '👷 Presente', absent: '🚫 Ausente' }, motor: { off: '⏹️ Apagado', on: '⚙️ Encendido' },
};
const CAUSES = { fire_detected: '🔥 Fuego detectado', water_high: '🌊 Nivel de agua alto', motor_on_without_operator: '⚙️ Motor encendido sin operador presente' };
const grid = document.getElementById('deviceGrid');
const feed = document.getElementById('feed');
const cards = new Map();
const feedItems = [];
const MAX_FEED = 12;
let currentState;

function setConnection(connected) {
  const status = document.getElementById('systemStatus');
  status.classList.toggle('connected', connected);
  status.classList.toggle('disconnected', !connected);
  document.getElementById('systemStatusText').textContent = connected ? 'Canal en vivo conectado' : 'Canal desconectado; reintentando...';
}

function addCard(device, index) {
  const card = document.createElement('article');
  card.className = 'device-card';
  const number = document.createElement('span');
  number.className = 'device-index';
  number.textContent = `DISPOSITIVO 0${index + 1}`;
  const title = document.createElement('h3');
  const icon = document.createElement('span');
  icon.className = 'device-emoji';
  icon.setAttribute('aria-hidden', 'true');
  icon.textContent = DEVICE_ICONS[device.type] || '📟';
  title.append(icon, document.createTextNode(device.name));
  const reading = document.createElement('div');
  reading.className = 'reading';
  const dot = document.createElement('span');
  dot.className = 'reading-dot';
  dot.setAttribute('aria-hidden', 'true');
  const value = document.createElement('strong');
  value.className = 'reading-value';
  reading.append(dot, value);
  const updated = document.createElement('p');
  updated.className = 'device-updated';
  card.append(number, title, reading, updated);
  grid.append(card);
  const elements = { reading, value, updated };
  cards.set(device.id, elements);
  return elements;
}

function renderAlarm(alarm = { active: false, causes: [] }) {
  const active = Boolean(alarm.active);
  document.getElementById('alarmPanel').classList.toggle('active', active);
  document.getElementById('alarmSymbol').textContent = active ? '🚨' : '✅';
  document.getElementById('alarmTitle').textContent = active ? 'Alarma activa' : 'Sistema sin alarmas';
  const causes = (alarm.causes || []).map((cause) => CAUSES[cause] || cause);
  document.getElementById('alarmDetails').textContent = causes.length ? causes.join(' · ') : 'Todos los dispositivos están dentro de las condiciones normales.';
  document.getElementById('alarmCode').textContent = active ? 'ALARMA / ACTIVA' : 'SISTEMA / NORMAL';
}

function renderFeed() {
  feed.replaceChildren();
  if (!feedItems.length) {
    const empty = document.createElement('p');
    empty.className = 'empty';
    empty.textContent = 'Esperando cambios de estado.';
    feed.append(empty);
    return;
  }
  feedItems.forEach((item) => {
    const row = document.createElement('div');
    row.className = 'feed-item';
    const time = document.createElement('time');
    time.className = 'feed-time';
    time.textContent = item.time;
    const message = document.createElement('div');
    message.className = 'feed-message';
    const source = document.createElement('span');
    source.className = 'feed-source';
    source.textContent = `${item.source} / `;
    message.append(source, document.createTextNode(`${item.device}: ${item.value}`));
    row.append(time, message);
    feed.append(row);
  });
}

function addFeedEvent(event) {
  if (!event?.changedDeviceId || !currentState) return;
  const device = currentState.devices.find(({ id }) => id === event.changedDeviceId);
  if (!device) return;
  feedItems.unshift({ time: new Date().toLocaleTimeString('es-MX'), device: device.name, value: LABELS[device.type]?.[String(device.value)] || 'Desconocido', source: event.source === 'mqtt' ? 'MQTT' : 'ADMIN' });
  feedItems.length = Math.min(feedItems.length, MAX_FEED);
  renderFeed();
}

function renderState(state, isUpdate = false, event) {
  if (!state || !Array.isArray(state.devices)) return;
  if (!cards.size) grid.replaceChildren();
  state.devices.forEach((device, index) => {
    const elements = cards.get(device.id) || addCard(device, index);
    elements.value.textContent = LABELS[device.type]?.[String(device.value)] || 'Desconocido';
    const alert = (device.type === 'fire' && device.value === true) || (device.type === 'water' && device.value === 'high');
    elements.reading.classList.toggle('alert', alert);
    elements.updated.textContent = device.updatedAt ? `ACTUALIZADO ${new Date(device.updatedAt).toLocaleTimeString('es-MX')}` : 'SIN ACTUALIZACIÓN';
  });
  currentState = state;
  renderAlarm(state.alarm);
  document.getElementById('lastUpdate').textContent = state.updatedAt ? `ÚLTIMO CAMBIO ${new Date(state.updatedAt).toLocaleTimeString('es-MX')}` : 'SIN DATOS';
  if (isUpdate) addFeedEvent(event);
}

async function loadState() {
  const response = await fetch(`${API}/devices`);
  if (!response.ok) throw new Error('No se pudo cargar el estado');
  renderState(await response.json());
}

function connectEvents() {
  const stream = new EventSource(`${API}/events`);
  stream.onopen = () => setConnection(true);
  stream.onerror = () => setConnection(false);
  stream.onmessage = (message) => {
    try {
      const event = JSON.parse(message.data);
      renderState(event.state, event.type === 'update', event);
    } catch (error) { setConnection(false); }
  };
}

loadState().catch(() => {
  document.getElementById('alarmDetails').textContent = 'No se pudo conectar con el servidor.';
  grid.textContent = 'No se pudieron cargar los dispositivos.';
}).finally(connectEvents);
