var type = 1;
var radius = '12em';
var offset = '14em';
var start = -180;
//var $elements = $('li:not(:first-child)');
var elements = Array.prototype.slice.call(document.getElementsByClassName('circle-element'));
var centerImage = elements.shift();
//var numberOfElements = (type === 1) ?  $elements.length : $elements.length - 1;
var numberOfElements = (type === 1) ?  elements.length : elements.length - 1;
var slice = 360 * type / numberOfElements;

centerImage.style.transform = 'translateY(' + offset + ')';
centerImage.style.listStyleType = 'none';
elements.forEach((element, index) => {
    var self = element,
        rotate = slice * index + start,
        rotateReverse = rotate * -1;
    element.style.transform = 'rotate(' + rotate + 'deg) translate(' + radius + ') rotate(' + rotateReverse + 'deg)' + ' translateY(' + offset + ')';
    element.style.listStyleType = 'none';
    console.log(rotate);

    // element.css({
    //     'transform': 'rotate(' + rotate + 'deg) translate(' + radius + ') rotate(' + rotateReverse + 'deg)'
    // });
});
