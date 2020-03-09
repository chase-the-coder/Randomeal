const selectPrice = () => {
  event.currentTarget.classList.toggle("selected");

  document.querySelectorAll(".selected").forEach((element) => {
    elem = document.getElementById("price-hidden").innerHTML;
    elem = elem + element.innerHTML;
  });
};

document.querySelectorAll(".price-range").forEach((element) => {
  element.addEventListener("click", selectPrice);
});
