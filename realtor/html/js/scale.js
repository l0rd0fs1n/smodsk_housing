function SetScale() {
    let scaleFactor = window.innerHeight / 1200;
    document.body.style.transform = 'scale(' + scaleFactor + ')';
    document.body.style['-o-transform'] = 'scale(' + scaleFactor + ')';
    document.body.style['-webkit-transform'] = 'scale(' + scaleFactor + ')';
    document.body.style['-moz-transform'] = 'scale(' + scaleFactor + ')';
}