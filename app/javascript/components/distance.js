const setDistance = () => {
  document.getElementById("distance").value = document.getElementById("demo").innerText
};

document.getElementById("demo").addEventListener("change", setDistance);
