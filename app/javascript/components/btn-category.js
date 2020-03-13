function onClick(e){
  if (e.currentTarget.id === 'btn-randomeal-cat') {
    e.currentTarget.setAttribute('id', 'btn-randomeal-cat-pressed');
    e.currentTarget.innerHTML = "Not in the mood for <i class='fas fa-angle-up'></i>";
  } else {
      e.currentTarget.setAttribute('id', 'btn-randomeal-cat');
      e.currentTarget.innerHTML = "Not in the mood for <i class='fas fa-angle-down'></i>";
  }
};
if (document.getElementById('btn-randomeal-cat')) {
  document.getElementById('btn-randomeal-cat').addEventListener('click', onClick);
}
