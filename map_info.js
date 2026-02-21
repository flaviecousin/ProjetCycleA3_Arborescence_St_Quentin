//alert("mAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAp&info")


function displayErrors(url){
    let messages = {
        400: 'Requête incorrecte',
        401: 'Authentifiez-vous',
        404: 'Page non trouvée',
        500: 'Erreur interne du serveur',
        503: 'Service indisponible'
        };
    switch(url){
        case 400:
            alert(messages[400]);
            break;
        case 401:
            alert(messages[401]);
            break;
        case 404:
            alert(messages[404]);
            break;
        case 500:
            alert(messages[500]);
            break;
        case 503:
            alert(messages[503]);
            break;
    }
}
    
function ajaxRequest(type,url,callback,data=null)
// data stocke le message envoyé
// data=null est un paramètre par défaut, utile si on ne veut mettre que 3 paramètres (=pas de message envoyé)
{
    // Create XML HTTP request
    let xhr = new XMLHttpRequest();
    xhr.open(type, url);
    xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded'); // For POST requests.
    
    // Add onload function
    xhr.onload = () => {
        switch (xhr.status) {
            case 200:
            case 201: console.log(xhr.responseText);
                console.log(JSON.parse(xhr.responseText));
                callback(JSON.parse(xhr.responseText));
                break;
            default: displayErrors(xhr.status)
        }
    };

    // Send XML HTTP request.
    xhr.send(data); // Data for POST requests

}

function displayNotif() {
    alert('COUCOU');
}

ajaxRequest('GET',"map_info.php?request=tableau",displayTab);

/*
function displayTab(tab){
    let ajout = document.querySelector('.table_arbre tbody');
    ajout.innerHTML = '';
    for (i = 0; i < tab.length; i++){
        let row=document.createElement('tr');
            row.innerHTML = `
            <td>${tab[i].longitude}</td>
            <td>${tab[i].latitude}</td>
            <td>${tab[i].Especes}</td>
            <td>${tab[i].hauteur_totale}</td>
            <td>${tab[i].hauteur_tronc}</td>
            <td>${tab[i].diametre_tronc}</td>
            <td>${tab[i].remarquable}</td>
            <td>${tab[i].id_stat_dev}</td>
            <td>${tab[i].id_pied}</td>
            <td>${tab[i].id_etat_de_l_arbre}</td>
            <td>${tab[i].id_port}</td> `;
            ajout.appendChild(row);
    }
    

}
*/
function displayTab(tab) {
    // Sélectionnez le corps du tableau
    let tbody = document.querySelector('.table_arbre tbody');
    
    // Effacez toutes les lignes existantes dans le corps du tableau
    tbody.innerHTML = '';
    
    // Parcourez chaque élément de tabArbre et créez une nouvelle ligne pour chacun
    for (let i = 0; i < tab.length; i++) {
        let row = document.createElement('tr');
        
        // Créez et ajoutez des cellules pour chaque propriété de l'objet tabArbre[i]
        row.innerHTML = `
            <td><input type="radio" name="selectedRow"></td>
            <td>${tab[i].longitude}</td>
            <td>${tab[i].latitude}</td>
            <td>${tab[i].Especes}</td>
            <td>${tab[i].hauteur_totale}</td>
            <td>${tab[i].hauteur_tronc}</td>
            <td>${tab[i].diametre_tronc}</td>
            <td>${tab[i].remarquable}</td>
            <td>${tab[i].id_stat_dev}</td>
            <td>${tab[i].id_pied}</td>
            <td>${tab[i].id_etat_de_l_arbre}</td>
            <td>${tab[i].id_port}</td> 
        `;
        
        // Ajoutez la ligne nouvellement créée au corps du tableau
        tbody.appendChild(row);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    fetch('map_info.php')
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Error from server:', data.error);
            } else {
                plotData(data);
            }
        })
        .catch(error => {
            console.error('Error loading data:', error);
        });
});

function plotData(data) {
    const validData = data.filter(row => {
        const lat = parseFloat(row.latitude);
        const lon = parseFloat(row.longitude);
        return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180;
    });

    console.log('Valid data:', validData);

    const lats = validData.map(row => parseFloat(row.latitude));
    const lons = validData.map(row => parseFloat(row.longitude));
    const texts = data.map(row => {
        return `Longitude: ${row.longitude}<br>Latitude: ${row.latitude}<br>Espèce: ${row.Especes}
        <br>Hauteur de l'arbre: ${row.hauteur_totale}<br>Hauteur du tronc: ${row.hauteur_tronc}
        <br>Diamètre du tronc : ${row.diametre_tronc}<br>Remarquable : ${row.remarquable}
        <br>Etat de l'arbre : ${row.etat_arbre}<br>Stade de développement : ${row.dev_arbre}`;

    console.log('Lats:', lats);
    console.log('Lons:', lons);
    console.log('Texts:', texts);
    
    });

    var plotData = [{
        type: 'scattermapbox',
        lat: lats,
        lon: lons,
        mode: 'markers',
        marker: {
            size: 9
        },
        text: texts, // Informations supplémentaires pour le popup
        hoverinfo: 'text' // Définir le type d'informations à afficher au survol
    }];

    var layout = {
        title: 'Emplacement des arbres de Saint Quentin',
        font: {
            color: 'black'
        },
        dragmode: 'zoom',
        mapbox: {
            center: {
                lat: 49.84,
                lon: 3.29
            },
            domain: {
                x: [0, 1],
                y: [0, 1]
            },
            style: 'light',
            zoom: 12
        },
        margin: {
            r: 20,
            t: 40,
            b: 20,
            l: 20,
            pad: 0
        },
        paper_bgcolor: '#191A1A',
        plot_bgcolor: '#191A1A',
        showlegend: false
    };

    Plotly.setPlotConfig({
        mapboxAccessToken: "pk.eyJ1IjoiZmxhdmllYyIsImEiOiJjbHh4MnJ4aDQxazNjMmpwZWEweTBiNHE0In0.hoWNR-djjmOOym92z-O99w"
    });

    Plotly.newPlot('myDiv', plotData, layout);
}
