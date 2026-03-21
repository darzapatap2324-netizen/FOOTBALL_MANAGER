// clasificacion.js - Calcula i mostra la classificació a partir dels partits

// Funció que canvia entre lliga masculina i femenina
function mostrarLliga(lliga) {
    var botons = document.querySelectorAll('.selector-lliga button');
    for (var i = 0; i < botons.length; i++) {
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

// Funció que llegeix el JSON de partits
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

// Funció que calcula les estadístiques de cada equip a partir dels partits
function calcularClassificacio(partits) {
    // Objecte que guardarà les dades de cada equip
    var classificacio = {};

    for (var i = 0; i < partits.length; i++) {
        var partit = partits[i];
        var nomLocal = partit.equip_local.nom;
        var nomVisitant = partit.equip_visitant.nom;

        // Si l'equip no existeix encara, el creem amb valors a 0
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

        // Obtenim els gols separant el resultat per "-"
        // Per exemple "2-1" -> golsLocal=2, golsVisitant=1
        var parts = partit.resultat.split('-');
        var golsLocal = parseInt(parts[0]);
        var golsVisitant = parseInt(parts[1]);

        // Actualitzem partits jugats i gols
        classificacio[nomLocal].pj = classificacio[nomLocal].pj + 1;
        classificacio[nomVisitant].pj = classificacio[nomVisitant].pj + 1;
        classificacio[nomLocal].gf = classificacio[nomLocal].gf + golsLocal;
        classificacio[nomLocal].gc = classificacio[nomLocal].gc + golsVisitant;
        classificacio[nomVisitant].gf = classificacio[nomVisitant].gf + golsVisitant;
        classificacio[nomVisitant].gc = classificacio[nomVisitant].gc + golsLocal;

        // Donem punts segons el resultat
        if (golsLocal > golsVisitant) {
            // Guanya el local
            classificacio[nomLocal].g = classificacio[nomLocal].g + 1;
            classificacio[nomLocal].pts = classificacio[nomLocal].pts + 3;
            classificacio[nomVisitant].p = classificacio[nomVisitant].p + 1;
        } else if (golsVisitant > golsLocal) {
            // Guanya el visitant
            classificacio[nomVisitant].g = classificacio[nomVisitant].g + 1;
            classificacio[nomVisitant].pts = classificacio[nomVisitant].pts + 3;
            classificacio[nomLocal].p = classificacio[nomLocal].p + 1;
        } else {
            // Empat
            classificacio[nomLocal].e = classificacio[nomLocal].e + 1;
            classificacio[nomVisitant].e = classificacio[nomVisitant].e + 1;
            classificacio[nomLocal].pts = classificacio[nomLocal].pts + 1;
            classificacio[nomVisitant].pts = classificacio[nomVisitant].pts + 1;
        }
    }

    // Convertim l'objecte a un array per poder ordenar-lo
    var llista = [];
    for (var nom in classificacio) {
        llista.push(classificacio[nom]);
    }

    // Ordenem per punts DESC, desempat per diferència de gols DESC
    llista.sort(function(a, b) {
        if (b.pts !== a.pts) {
            return b.pts - a.pts;
        }
        return (b.gf - b.gc) - (a.gf - a.gc);
    });

    pintarClassificacio(llista);
}

// Funció que pinta la taula de classificació
function pintarClassificacio(llista) {
    var taula = document.getElementById('taula-classificacio');
    taula.innerHTML = '';

    for (var i = 0; i < llista.length; i++) {
        var eq = llista[i];
        var dif = eq.gf - eq.gc;
        var difText = dif > 0 ? '+' + dif : dif;

        var fila = '<tr>';
        fila += '<td class="pos">' + (i + 1) + '</td>';
        fila += '<td><div class="nom-equip">';
        fila += '<img src="' + eq.escut + '" alt="' + eq.nom + '">';
        fila += '<span>' + eq.nom + '</span>';
        fila += '</div></td>';
        fila += '<td>' + eq.pj + '</td>';
        fila += '<td>' + eq.g + '</td>';
        fila += '<td>' + eq.e + '</td>';
        fila += '<td>' + eq.p + '</td>';
        fila += '<td>' + eq.gf + '</td>';
        fila += '<td>' + eq.gc + '</td>';
        fila += '<td>' + difText + '</td>';
        fila += '<td class="punts">' + eq.pts + '</td>';
        fila += '</tr>';

        taula.innerHTML += fila;
    }
}

// Quan es carrega la pàgina, mostrem la lliga masculina per defecte
carregarClassificacio('Json/FM_partits_masc.json');