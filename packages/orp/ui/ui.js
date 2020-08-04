
CallEvent = ue.game.callevent;

let CashDisplay = document.getElementById("CashText")
let BankDisplay = document.getElementById("BankText")
let DirtyMoneyDisplay = document.getElementById("DirtyMoneyText")
let JobDisplay = document.getElementById("JobText")
let PlayerList = document.getElementById("PlayerList")

$("#PlayerList").fadeOut(0)

function UpdateCash(cash){
	CashDisplay.innerHTML = cash
}

function UpdateBank(bank){
	BankDisplay.innerHTML = bank
}

function UpdateDirtyMoney(dirtymoney){
	DirtyMoneyDisplay.innerHTML = dirtymoney
}

function UpdateJob(job, jobrank){
	JobDisplay.innerHTML = "&nbsp" + job + " | " + jobrank
	JobDisplay.style.textTransform = "capitalize"
}

let offCol = false
function AppendPlayerInfo(id, name, steamid, ping) {
	var PlayerListing = document.createElement('DIV')
	var HR = document.createElement('HR')
	PlayerListing.classList.add = "PlyListing"

	PlayerListing.plyID = id
	PlayerListing.plyName = name
	PlayerListing.SteamID = steamid
	PlayerListing.ping = ping
	PlayerListing.style.height = "45px"
	if ( offCol == false ) {
		offCol = true
		PlayerListing.style.backgroundColor = "rgba(68, 180, 184, 0.2)"
	} else {
		offCol = false
		PlayerListing.style.backgroundColor = "white"
	}

	PlayerListing.style.display = "flex"
	PlayerListing.style.justifyContent = "space-evenly"
	PlayerListing.style.alignContent = "center"
	
	PlayerListing.innerHTML = '<p>' + id + '</p> <p>' + name + '</p> <p>' + steamid + '</p> <p>' + ping + '</p>'

	document.getElementById("PLBody").appendChild(PlayerListing)
	// document.getElementById("PLBody").appendChild(HR)
}

function ShowPlayerList() {
	$("#PlayerList").fadeIn(250)
}


function HidePlayerList() {
	$("#PlayerList").fadeOut(250)
	var PlayerListings = document.getElementById("PLBody")
    while (PlayerListings.lastChild) {
		console.log(PlayerListings.lastChild.id )
		if ( PlayerListings.lastChild.id !== "topBar" ) {
			PlayerListings.removeChild(PlayerListings.lastChild);
		} else {
			offCol = false
			return
		}
    }
}

function KeyUp(event) {
	console.log(event.which, event.keyCode)
}