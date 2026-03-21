// equipos.js - Carrega els equips i jugadors des del JSON

// Funció que canvia entre lliga masculina i femenina
function mostrarLliga(lliga) {
    // Canviem el botó actiu
    var botons = document.querySelectorAll('.selector-lliga button');
    for (var i = 0; i < botons.length; i++) {
        botons[i].classList.remove('actiu');
    }

    if (lliga === 'masc') {
        botons[0].classList.add('actiu');
        carregarEquips('Json/jugadors.json');
    } else {
        botons[1].classList.add('actiu');
        carregarEquips('Json/jugadores.json');
    }
}

// Funció que llegeix el fitxer JSON i crida pintarEquips
function carregarEquips(fitxer) {
    fetch(fitxer)
        .then(function(resposta) {
            return resposta.json();
        })
        .then(function(dades) {
            pintarEquips(dades);
        })
        .catch(function(error) {
            console.log('Error carregant el JSON: ' + error);
        });
}

// Funció que crea el HTML de cada equip i el posa al contenidor
function pintarEquips(equips) {
    var contenidor = document.getElementById('contenidor-equips');
    contenidor.innerHTML = '';

    for (var i = 0; i < equips.length; i++) {
        var equip = equips[i];

        var htmlEquip = '<div class="equip">';

        // Capçalera: escut i nom de l'equip
        htmlEquip += '<div class="equip-header">';
        htmlEquip += '<img src="' + equip.escut + '" alt="Escut ' + equip.equip + '">';
        htmlEquip += '<h2>' + equip.equip + '</h2>';
        htmlEquip += '</div>';

        // Entrenador
        htmlEquip += '<div class="entrenador">';
        htmlEquip += '<img src="' + equip.entrenador.foto + '" alt="' + equip.entrenador.nomPersona + '">';
        htmlEquip += '<div>';
        htmlEquip += '<span>Entrenador/a</span>';
        htmlEquip += '<strong>' + equip.entrenador.nomPersona + '</strong>';
        htmlEquip += '</div>';
        htmlEquip += '</div>';

        // Jugadors
        htmlEquip += '<div class="jugadors-grid">';
        for (var j = 0; j < equip.jugadors.length; j++) {
            var jugador = equip.jugadors[j];
            htmlEquip += '<div class="jugador">';
            htmlEquip += '<img src="' + jugador.foto + '" alt="' + jugador.nomPersona + '">';
            htmlEquip += '<div class="dorsal">' + jugador.dorsal + '</div>';
            htmlEquip += '<div class="nom">' + jugador.nomPersona + '</div>';
            htmlEquip += '<div class="posicio">' + jugador.posicio + '</div>';
            htmlEquip += '<div class="qualitat">⭐ ' + jugador.qualitat + '</div>';
            htmlEquip += '</div>';
        }
        htmlEquip += '</div>';

        htmlEquip += '</div>';
        contenidor.innerHTML += htmlEquip;
    }
}

// Quan es carrega la pàgina, mostrem la lliga masculina per defecte
carregarEquips('Json/jugadors.json');