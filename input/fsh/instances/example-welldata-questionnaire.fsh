Instance: questionnaire-zipster
InstanceOf: WellDataQuestionnaire
Usage: #example
Title: "Zipster Vragenlijst 3.0"
Description: "Example questionnaire based on the Zipster vragenlijst (versie 3.0)."
* id = "questionnaire-zipster"
* identifier.system = "https://well-data.example.org/fhir/Questionnaire"
* identifier.value = "zipster-3-0"
* name = "ZipsterVragenlijst3_0"
* title = "Zipster Vragenlijst 3.0"
* status = #draft
* date = "2025-06-10"
* publisher = "Zipster / WellData Consortium"
* subjectType[0] = #Patient

* item[0].linkId = "1.1"
* item[0].text = "Heeft een chronische ziekte"
* item[0].type = #choice
* item[0].answerOption[0].valueString = "Ja"
* item[0].answerOption[1].valueString = "Nee"

* item[1].linkId = "1.2"
* item[1].text = "Heeft een mentale / fysische beperking"
* item[1].type = #choice
* item[1].answerOption[0].valueString = "Ja"
* item[1].answerOption[1].valueString = "Nee"

* item[2].linkId = "1.3"
* item[2].text = "Heeft een probleem met gezondheidsgeletterdheid"
* item[2].type = #choice
* item[2].answerOption[0].valueString = "Ja"
* item[2].answerOption[1].valueString = "Nee"

* item[3].linkId = "1.4"
* item[3].text = "Kan rekenen op professionele steun/steun uit de omgeving of heeft een pasalarm"
* item[3].type = #choice
* item[3].answerOption[0].valueString = "Ja"
* item[3].answerOption[1].valueString = "Nee"

* item[4].linkId = "1.5"
* item[4].text = "Is ouder/voogd en/of mantelzorger"
* item[4].type = #choice
* item[4].answerOption[0].valueString = "Ja"
* item[4].answerOption[1].valueString = "Nee"

* item[5].linkId = "2.1"
* item[5].text = "Heeft beperkte toegang tot gezond voedsel?"
* item[5].type = #choice
* item[5].answerOption[0].valueString = "Ja"
* item[5].answerOption[1].valueString = "Nee"

* item[6].linkId = "2.2"
* item[6].text = "Is er behoefte aan ondersteuning rond sociaal netwerk/alleenstaand?"
* item[6].type = #choice
* item[6].answerOption[0].valueString = "Ja"
* item[6].answerOption[1].valueString = "Nee"

* item[7].linkId = "2.3"
* item[7].text = "Heeft beperkte toegang tot huisvesting?"
* item[7].type = #choice
* item[7].answerOption[0].valueString = "Ja"
* item[7].answerOption[1].valueString = "Nee"

* item[8].linkId = "2.4"
* item[8].text = "Heeft financiële problemen die gezondheidszorg beïnvloeden?"
* item[8].type = #choice
* item[8].answerOption[0].valueString = "Ja"
* item[8].answerOption[1].valueString = "Nee"

* item[9].linkId = "2.5"
* item[9].text = "Heeft problemen met stress of mentale gezondheid?"
* item[9].type = #choice
* item[9].answerOption[0].valueString = "Ja"
* item[9].answerOption[1].valueString = "Nee"

* item[10].linkId = "2.6"
* item[10].text = "Is er nood aan ondersteuning bij gezinsplanning of kinderopvang?"
* item[10].type = #choice
* item[10].answerOption[0].valueString = "Ja"
* item[10].answerOption[1].valueString = "Nee"

* item[11].linkId = "2.7"
* item[11].text = "Is er beperkte toegang tot vervoer voor gezondheidszorg?"
* item[11].type = #choice
* item[11].answerOption[0].valueString = "Ja"
* item[11].answerOption[1].valueString = "Nee"

* item[12].linkId = "2.8"
* item[12].text = "Is er nood aan ondersteuning bij  digitale kwetsbaarheid?"
* item[12].type = #choice
* item[12].answerOption[0].valueString = "Ja"
* item[12].answerOption[1].valueString = "Nee"

* item[13].linkId = "2.9"
* item[13].text = "Is er nood aaan ondersteuning rond mobiliteit of toegankelijkheid?"
* item[13].type = #choice
* item[13].answerOption[0].valueString = "Ja"
* item[13].answerOption[1].valueString = "Nee"