
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
    
