// equipos.js - Carrega els equips i jugadors des del JSON

function mostrarLliga(lliga) {
    let botons = document.querySelectorAll('.selector-lliga button');
    for (let i = 0; i < botons.length; i++) {
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

function pintarEquips(equips) {
    let contenidor = document.getElementById('contenidor-equips');
    contenidor.textContent = '';

    for (let i = 0; i < equips.length; i++) {
        let equip = equips[i];

        // Targeta de l'equip
        let divEquip = document.createElement('div');
        divEquip.classList.add('equip');

        // Capçalera: escut i nom
        let divHeader = document.createElement('div');
        divHeader.classList.add('equip-header');

        let imgEscut = document.createElement('img');
        imgEscut.src = equip.escut;
        imgEscut.alt = 'Escut ' + equip.equip;
        divHeader.appendChild(imgEscut);

        let h2 = document.createElement('h2');
        h2.textContent = equip.equip;
        divHeader.appendChild(h2);

        divEquip.appendChild(divHeader);

        // Entrenador
        let divEntrenador = document.createElement('div');
        divEntrenador.classList.add('entrenador');

        let imgEntrenador = document.createElement('img');
        imgEntrenador.src = equip.entrenador.foto;
        imgEntrenador.alt = equip.entrenador.nomPersona;
        divEntrenador.appendChild(imgEntrenador);

        let divInfoEntrenador = document.createElement('div');

        let spanTitol = document.createElement('span');
        spanTitol.textContent = 'Entrenador/a';
        divInfoEntrenador.appendChild(spanTitol);

        let strong = document.createElement('strong');
        strong.textContent = equip.entrenador.nomPersona;
        divInfoEntrenador.appendChild(strong);

        divEntrenador.appendChild(divInfoEntrenador);
        divEquip.appendChild(divEntrenador);

        // Jugadors
        let divJugadors = document.createElement('div');
        divJugadors.classList.add('jugadors-grid');

        for (let j = 0; j < equip.jugadors.length; j++) {
            let jugador = equip.jugadors[j];

            let divJugador = document.createElement('div');
            divJugador.classList.add('jugador');

            let imgJugador = document.createElement('img');
            imgJugador.src = jugador.foto;
            imgJugador.alt = jugador.nomPersona;
            divJugador.appendChild(imgJugador);

            let divDorsal = document.createElement('div');
            divDorsal.classList.add('dorsal');
            divDorsal.textContent = jugador.dorsal;
            divJugador.appendChild(divDorsal);

            let divNom = document.createElement('div');
            divNom.classList.add('nom');
            divNom.textContent = jugador.nomPersona;
            divJugador.appendChild(divNom);

            let divPosicio = document.createElement('div');
            divPosicio.classList.add('posicio');
            divPosicio.textContent = jugador.posicio;
            divJugador.appendChild(divPosicio);

            let divQualitat = document.createElement('div');
            divQualitat.classList.add('qualitat');
            divQualitat.textContent = '⭐ ' + jugador.qualitat;
            divJugador.appendChild(divQualitat);

            divJugadors.appendChild(divJugador);
        }

        divEquip.appendChild(divJugadors);
        contenidor.appendChild(divEquip);
    }
}

carregarEquips('Json/jugadors.json');