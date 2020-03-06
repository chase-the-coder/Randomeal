const slider = () => {
  var sliderObject = document.getElementById('slider');
  console.log('teste')
  noUiSlider.create(sliderObject, {
      start: [20, 80],
      connect: true,
      range: {
          'min': 0,
          'max': 100
      }
  });
};
export { slider };
