let equips = [
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

let select = document.getElementById('equip');
for (let i = 0; i < equips.length; i++) {
    let opcio = document.createElement('option');
    opcio.value = equips[i];
    opcio.textContent = equips[i];
    select.appendChild(opcio);
}

function canviarTipus() {
    let tipus = document.querySelector('input[name="tipus"]:checked').value;
    let seccio = document.getElementById('seccio-posicions');

    if (tipus === 'jugador') {
        seccio.style.display = 'block';
    } else {
        seccio.style.display = 'none';
    }
}