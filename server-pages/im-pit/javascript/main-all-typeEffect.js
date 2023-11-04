const TypeWriter = function(txtElement, words, wait = 3000){
    this.txtElement = txtElement;
    this.words = words;
    this.txt = '';
    this.wordIndex = 0;
    this.wait = parseInt(wait, 10);
    this.type();
    this.isDeleting = false;
}

TypeWriter.prototype.type = function(){
    const current = this.wordIndex % this.words.length;
    const fullTxt = this.words[current];

    if(this.isDeleting){
        this.txt = fullTxt.substring(0, this.txt.length - 1);
    }else{
        this.txt = fullTxt.substring(0, this.txt.length + 1);
    }

    this.txtElement.innerHTML = `<p id="txt">${this.txt}|</p>`;

    let typeSpeed = 100;

    if(this.isDeleting){
        typeSpeed /= 2;
    }

    if(!this.isDeleting && this.txt === fullTxt){
        typeSpeed = this.wait;
        this.isDeleting = true;
    } else if(this.isDeleting && this.txt === ''){
        this.isDeleting = false;
        this.wordIndex++;
        typeSpeed = 500;
    }

    setTimeout(() => this.type(), typeSpeed)
}

document.addEventListener('DOMContentLoaded', init1);
document.addEventListener('DOMContentLoaded', init2);
document.addEventListener('DOMContentLoaded', init3);
document.addEventListener('DOMContentLoaded', init4);

function init1(){
    const txtElement = document.getElementById('txt-typeFirst');
    const words = JSON.parse(txtElement.getAttribute('data-words'));
    const wait = txtElement.getAttribute('data-wait');

    new TypeWriter(txtElement, words, wait);
}

function init2(){
    const txtElement = document.getElementById('txt-typeSecond');
    const words = JSON.parse(txtElement.getAttribute('data-words'));
    const wait = txtElement.getAttribute('data-wait');

    new TypeWriter(txtElement, words, wait);
}

function init3(){
    const txtElement = document.getElementById('txt-typeThird');
    const words = JSON.parse(txtElement.getAttribute('data-words'));
    const wait = txtElement.getAttribute('data-wait');

    new TypeWriter(txtElement, words, wait);
}

function init4(){
    const txtElement = document.getElementById('txt-typeFourth');
    const words = JSON.parse(txtElement.getAttribute('data-words'));
    const wait = txtElement.getAttribute('data-wait');

    new TypeWriter(txtElement, words, wait);
}