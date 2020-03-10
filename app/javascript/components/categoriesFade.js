cards = document.querySelectorAll(".category")
const select = () => {
  event.currentTarget.classList.toggle("active");
  const categories = [];
  const categoryInput = document.getElementById("category-hidden");
  document.querySelectorAll(".active").forEach((element) => {
  categories.push(element.innerText);
  });
  if (categories.length == 0) {
    categoryInput.value = "";
  } else {
    categoryInput.value = categories.join(",");
  }
};
cards.forEach((card) => {
  card.addEventListener("click", select)
});
