//alert("Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadd_tree");


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



// channels-... = id du select concerné

// ----------------- Récupération des états d'arbre -----------------
getEtat();
function getEtat()
{
    ajaxRequest('GET','php/add_tree.php?request=etat_de_l_arbre',displayEtat)
}

function displayEtat(channels)
{
    let select;
    select=document.getElementById('etat_de_l_arbre');
    for (let i=0;i<channels.length;i++)
    {
        select.innerHTML+='<option value='+channels[i].id_etat_de_l_arbre+'>'+channels[i].etat_arbre + '</option>';
    }
}

// ----------------- Récupération du type de port des arbres -----------------
getPort();
function getPort()
{
    ajaxRequest('GET','php/add_tree.php?request=Port',displayPort)
}

function displayPort(channels)
{
    let select;
    select=document.getElementById('port');
    for (let i=0;i<channels.length;i++)
    {
        select.innerHTML+='<option value='+channels[i].id_port+'>'+channels[i].port_arbre + '</option>';
    }
    //setInterval(getInfo_etat,1000);
}

// ----------------- Récupération du type de pied des arbres -----------------
getPied();
function getPied()
{
    ajaxRequest('GET','php/add_tree.php?request=pied',displayPied)
}

function displayPied(channels)
{
    let select;
    select=document.getElementById('pied');
    for (let i=0;i<channels.length;i++)
    {
        select.innerHTML+='<option value='+channels[i].id_pied+'>'+channels[i].pied_arbre + '</option>';
    }
    //setInterval(getInfo_etat,1000);
}

// ----------------- Récupération des stades de développement des arbres -----------------
getStade();
function getStade()
{
    ajaxRequest('GET','php/add_tree.php?request=stat_dev',displayStade)
}

function displayStade(channels)
{
    let select;
    select=document.getElementById('stade_dev_arbre');
    for (let i=0;i<channels.length;i++)
    {
        select.innerHTML+='<option value='+channels[i].id_stat_dev+'>'+channels[i].dev_arbre + '</option>';
    }
}

// FIN RECUPERATION DES SELECTS

// ENVOI D`UN ARBRE

function sendArbre(event){
    console.log("on verifie");
    event.preventDefault();
    let id=[];
    id.push(document.getElementById("longitude").value);//canal concerné
    id.push(document.getElementById("latitude").value);
    id.push(document.getElementById("etat_de_l_arbre").value);
    id.push(document.getElementById("espece").value);
    id.push(document.getElementById("remarquable").value);
    id.push(document.getElementById("feuillage").value);
    id.push(document.getElementById("h_tot").value);
    id.push(document.getElementById("h_tronc").value);
    id.push(document.getElementById("d_tronc").value);
    id.push(document.getElementById("port").value);
    id.push(document.getElementById("pied").value);
    id.push(document.getElementById("stade_dev_arbre").value);

    let data = "&longitude="+id[0]+"&latitude="+id[1]+"&etat_de_l_arbre="+id[2]+"&espece="+id[3]+"&remarquable="+id[4]+"&feuillage="+id[5]+"&h_tot="+id[6]+"&h_tronc="+id[7]+"&d_tronc="+id[8]+"&port="+id[9]+"&pied="+id[10]+"&stade_dev_arbre="+id[11];
    console.log(data);
    ajaxRequest('POST',"php/add_tree.php?request=send_arbre",displayNotif,data);
    
    // let fields = ["longitude", "latitude", "etat__de_l_arbre", "espece", "remarquable", "feuillage", "h_tot", "h_tronc", "d_tronc", "port", "pied", "stadedev"];
    
    // fields.forEach(function (field) {
    //     document.getElementById(field).value = "";
    // });
    
}

function displayNotif() {
    alert('Arbre envoyé!');
}


document.getElementById('add_arbre').addEventListener('submit',sendArbre);
