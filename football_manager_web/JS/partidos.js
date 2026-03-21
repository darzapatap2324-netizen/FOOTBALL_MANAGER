// resultados.js - Carrega els partits des del JSON

function mostrarLliga(lliga) {
    let botons = document.querySelectorAll('.selector-lliga button');
    for (let i = 0; i < botons.length; i++) {
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

function formatarData(dataString) {
    let data = new Date(dataString);
    let opcions = {
        weekday: 'long',
        day: 'numeric',
        month: 'long',
        hour: '2-digit',
        minute: '2-digit'
    };
    return data.toLocaleDateString('es-ES', opcions);
}

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

function pintarPartits(partits) {
    let contenidor = document.getElementById('contenidor-partits');
    contenidor.textContent = '';

    for (let i = 0; i < partits.length; i++) {
        let partit = partits[i];

        let divPartit = document.createElement('div');
        divPartit.classList.add('partit');

        // Data
        let divData = document.createElement('div');
        divData.classList.add('partit-data');
        divData.textContent = formatarData(partit.data);
        divPartit.appendChild(divData);

        let divInfo = document.createElement('div');
        divInfo.classList.add('partit-info');

        // Equip local
        let divLocal = document.createElement('div');
        divLocal.classList.add('equip-partit');

        let imgLocal = document.createElement('img');
        imgLocal.src = partit.equip_local.escut;
        imgLocal.alt = partit.equip_local.nom;
        divLocal.appendChild(imgLocal);

        let spanLocal = document.createElement('span');
        spanLocal.textContent = partit.equip_local.nom;
        divLocal.appendChild(spanLocal);

        divInfo.appendChild(divLocal);

        // Resultat
        let divResultat = document.createElement('div');
        divResultat.classList.add('resultat');
        divResultat.textContent = partit.resultat;
        divInfo.appendChild(divResultat);

        // Equip visitant
        let divVisitant = document.createElement('div');
        divVisitant.classList.add('equip-partit');

        let imgVisitant = document.createElement('img');
        imgVisitant.src = partit.equip_visitant.escut;
        imgVisitant.alt = partit.equip_visitant.nom;
        divVisitant.appendChild(imgVisitant);

        let spanVisitant = document.createElement('span');
        spanVisitant.textContent = partit.equip_visitant.nom;
        divVisitant.appendChild(spanVisitant);

        divInfo.appendChild(divVisitant);
        divPartit.appendChild(divInfo);
        contenidor.appendChild(divPartit);
    }
}

carregarPartits('Json/FM_partits_masc.json');