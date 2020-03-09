cards = document.querySelectorAll(".category")
const select = () => {
  event.currentTarget.classList.toggle("active")
};
cards.forEach((card) => {
  card.addEventListener("click", select)
});
