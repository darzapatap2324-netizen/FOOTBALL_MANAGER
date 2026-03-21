// clasificacion.js - Calcula i mostra la classificació a partir dels partits

function mostrarLliga(lliga) {
    let botons = document.querySelectorAll('.selector-lliga button');
    for (let i = 0; i < botons.length; i++) {
        botons[i].classList.remove('actiu');
    }

    if (lliga === 'masc') {
        botons[0].classList.add('actiu');
        carregarClassificacio('Json/FM_partits_masc.json');
    } else {
        botons[1].classList.add('actiu');
        carregarClassificacio('Json/FM_partits_fem.json');
    }
}

function carregarClassificacio(fitxer) {
    fetch(fitxer)
        .then(function(resposta) {
            return resposta.json();
        })
        .then(function(partits) {
            calcularClassificacio(partits);
        })
        .catch(function(error) {
            console.log('Error: ' + error);
        });
}

function calcularClassificacio(partits) {
    let classificacio = {};

    for (let i = 0; i < partits.length; i++) {
        let partit = partits[i];
        let nomLocal = partit.equip_local.nom;
        let nomVisitant = partit.equip_visitant.nom;

        if (classificacio[nomLocal] === undefined) {
            classificacio[nomLocal] = {
                nom: nomLocal,
                escut: partit.equip_local.escut,
                pj: 0, g: 0, e: 0, p: 0,
                gf: 0, gc: 0, pts: 0
            };
        }
        if (classificacio[nomVisitant] === undefined) {
            classificacio[nomVisitant] = {
                nom: nomVisitant,
                escut: partit.equip_visitant.escut,
                pj: 0, g: 0, e: 0, p: 0,
                gf: 0, gc: 0, pts: 0
            };
        }

        let parts = partit.resultat.split('-');
        let golsLocal = parseInt(parts[0]);
        let golsVisitant = parseInt(parts[1]);

        classificacio[nomLocal].pj = classificacio[nomLocal].pj + 1;
        classificacio[nomVisitant].pj = classificacio[nomVisitant].pj + 1;
        classificacio[nomLocal].gf = classificacio[nomLocal].gf + golsLocal;
        classificacio[nomLocal].gc = classificacio[nomLocal].gc + golsVisitant;
        classificacio[nomVisitant].gf = classificacio[nomVisitant].gf + golsVisitant;
        classificacio[nomVisitant].gc = classificacio[nomVisitant].gc + golsLocal;

        if (golsLocal > golsVisitant) {
            classificacio[nomLocal].g = classificacio[nomLocal].g + 1;
            classificacio[nomLocal].pts = classificacio[nomLocal].pts + 3;
            classificacio[nomVisitant].p = classificacio[nomVisitant].p + 1;
        } else if (golsVisitant > golsLocal) {
            classificacio[nomVisitant].g = classificacio[nomVisitant].g + 1;
            classificacio[nomVisitant].pts = classificacio[nomVisitant].pts + 3;
            classificacio[nomLocal].p = classificacio[nomLocal].p + 1;
        } else {
            classificacio[nomLocal].e = classificacio[nomLocal].e + 1;
            classificacio[nomVisitant].e = classificacio[nomVisitant].e + 1;
            classificacio[nomLocal].pts = classificacio[nomLocal].pts + 1;
            classificacio[nomVisitant].pts = classificacio[nomVisitant].pts + 1;
        }
    }

    let llista = [];
    for (let nom in classificacio) {
        llista.push(classificacio[nom]);
    }

    llista.sort(function(a, b) {
        if (b.pts !== a.pts) {
            return b.pts - a.pts;
        }
        return (b.gf - b.gc) - (a.gf - a.gc);
    });

    pintarClassificacio(llista);
}

function pintarClassificacio(llista) {
    let taula = document.getElementById('taula-classificacio');
    taula.textContent = '';

    for (let i = 0; i < llista.length; i++) {
        let eq = llista[i];
        let dif = eq.gf - eq.gc;
        let difText;
        if (dif > 0) {
            difText = '+' + dif;
        } else {
            difText = dif;
        }

        // Creem la fila
        let fila = document.createElement('tr');

        // Posició
        let tdPos = document.createElement('td');
        tdPos.classList.add('pos');
        tdPos.textContent = i + 1;
        fila.appendChild(tdPos);

        // Nom equip amb escut
        let tdNom = document.createElement('td');
        let divNomEquip = document.createElement('div');
        divNomEquip.classList.add('nom-equip');

        let img = document.createElement('img');
        img.src = eq.escut;
        img.alt = eq.nom;
        divNomEquip.appendChild(img);

        let span = document.createElement('span');
        span.textContent = eq.nom;
        divNomEquip.appendChild(span);

        tdNom.appendChild(divNomEquip);
        fila.appendChild(tdNom);

        // PJ, G, E, P, GF, GC, Dif, Pts
        let valors = [eq.pj, eq.g, eq.e, eq.p, eq.gf, eq.gc, difText, eq.pts];
        for (let j = 0; j < valors.length; j++) {
            let td = document.createElement('td');
            td.textContent = valors[j];
            if (j === valors.length - 1) {
                td.classList.add('punts');
            }
            fila.appendChild(td);
        }

        taula.appendChild(fila);
    }
}

carregarClassificacio('Json/FM_partits_masc.json');