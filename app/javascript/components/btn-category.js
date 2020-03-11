document.getElementById('btn-randomeal-cat').addEventListener('click', onClick);

function onClick(e){
  if (e.currentTarget.id === 'btn-randomeal-cat') {
    e.currentTarget.setAttribute('id', 'btn-randomeal-cat-pressed');
  } else {
      e.currentTarget.setAttribute('id', 'btn-randomeal-cat');
  }
};
