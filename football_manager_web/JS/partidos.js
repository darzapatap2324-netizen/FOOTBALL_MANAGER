// resultados.js - Carrega els partits des del JSON

// Funció que canvia entre lliga masculina i femenina
function mostrarLliga(lliga) {
    var botons = document.querySelectorAll('.selector-lliga button');
    for (var i = 0; i < botons.length; i++) {
        botons[i].classList.remove('actiu');
    }

    if (lliga === 'masc') {
        botons[0].classList.add('actiu');
        carregarPartits('Json/FM_partits_masc.json');
    } else {
        botons[1].classList.add('actiu');
        carregarPartits('Json/FM_partits_fem.json');
    }
}

// Funció que formata la data del JSON a un format llegible
// La data del JSON té aquest format: "2025-03-15T16:00:00"
function formatarData(dataString) {
    var data = new Date(dataString);

    // Mostrem: dia de la setmana, dia, mes i hora
    var opcions = {
        weekday: 'long',
        day: 'numeric',
        month: 'long',
        hour: '2-digit',
        minute: '2-digit'
    };

    return data.toLocaleDateString('es-ES', opcions);
}

// Funció que llegeix el fitxer JSON de partits
function carregarPartits(fitxer) {
    fetch(fitxer)
        .then(function(resposta) {
            return resposta.json();
        })
        .then(function(dades) {
            pintarPartits(dades);
        })
        .catch(function(error) {
            console.log('Error carregant el JSON: ' + error);
        });
}

// Funció que crea el HTML de cada partit i el posa al contenidor
function pintarPartits(partits) {
    var contenidor = document.getElementById('contenidor-partits');
    contenidor.innerHTML = '';

    for (var i = 0; i < partits.length; i++) {
        var partit = partits[i];

        var htmlPartit = '<div class="partit">';

        // Data del partit
        htmlPartit += '<div class="partit-data">📅 ' + formatarData(partit.data) + '</div>';

        // Equips i resultat
        htmlPartit += '<div class="partit-info">';

        // Equip local
        htmlPartit += '<div class="equip-partit">';
        htmlPartit += '<img src="' + partit.equip_local.escut + '" alt="' + partit.equip_local.nom + '">';
        htmlPartit += '<span>' + partit.equip_local.nom + '</span>';
        htmlPartit += '</div>';

        // Resultat
        htmlPartit += '<div class="resultat">' + partit.resultat + '</div>';

        // Equip visitant
        htmlPartit += '<div class="equip-partit">';
        htmlPartit += '<img src="' + partit.equip_visitant.escut + '" alt="' + partit.equip_visitant.nom + '">';
        htmlPartit += '<span>' + partit.equip_visitant.nom + '</span>';
        htmlPartit += '</div>';

        htmlPartit += '</div>';
        htmlPartit += '</div>';

        contenidor.innerHTML += htmlPartit;
    }
}

// Quan es carrega la pàgina, mostrem la lliga masculina per defecte
carregarPartits('Json/FM_partits_masc.json');