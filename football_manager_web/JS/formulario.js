// formulario.js - Omple el desplegable d'equips i gestiona el formulari

// Llista d'equips per omplir el desplegable
var equips = [
    'FC Barcelona',
    'Real Madrid CF',
    'Atlético de Madrid',
    'Sevilla FC',
    'Real Sociedad',
    'Athletic Club',
    'Villarreal CF',
    'Real Betis',
    'Valencia CF',
    'Celta de Vigo'
];

// Omplim el desplegable amb els equips de la llista
var select = document.getElementById('equip');
for (var i = 0; i < equips.length; i++) {
    var opcio = document.createElement('option');
    opcio.value = equips[i];
    opcio.textContent = equips[i];
    select.appendChild(opcio);
}

// Funció que amaga o mostra les posicions segons si és jugador o entrenador
function canviarTipus() {
    var tipus = document.querySelector('input[name="tipus"]:checked').value;
    var seccio = document.getElementById('seccio-posicions');

    if (tipus === 'jugador') {
        seccio.style.display = 'block';
    } else {
        seccio.style.display = 'none';
    }
}