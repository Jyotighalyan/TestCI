{
  "form": {
    "type": "ISSUE",
    "title": "Create Issue",
    "actions": [
      {
        "method": "PUT",
        "source": "https://ker-l-jirapp02t.unity.media.corp/rest/cwx-sol-rest/latest/sol/aob/object/form/issue/bbs/12101",
        "title": "Save ISSUE"
      }
    ],
    "key": "/issue/bbs/12101",
    "attributevalues": [
      {
        "valuelist": [
          {
            "valuedescription": "New Fiber 2.0",
            "icon": "https://ker-l-jirapp02t.unity.media.corp/secure/viewavatar?size=xsmall&avatarId=12000&avatarType=issuetype",
            "value": "12101"
          }
        ],
        "control": "required,readonly",
        "attribute": "issuetype",
        "position": "0001",
        "title": "Vorgangstyp",
        "type": "issuetype"
      },
      {
        "attribute": "customfield_14593",
        "position": "0002",
        "title": "TA-Partner (Telefon)",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "Herr",
            "value": "12968"
          },
          {
            "valuedescription": "Frau",
            "value": "12969"
          }
        ],
        "attribute": "customfield_14594",
        "position": "0003",
        "title": "TA-Partner (Anrede)",
        "type": "option"
      },
      {
        "attribute": "customfield_14591",
        "position": "0004",
        "title": "TA-Partner (Mobil)",
        "type": "string"
      },
      {
        "attribute": "customfield_14592",
        "position": "0005",
        "title": "TA-Partner (E-Mail)",
        "type": "string"
      },
      {
        "attribute": "description",
        "position": "0006",
        "title": "Beschreibung",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "B2B Solutions",
            "value": "11701"
          }
        ],
        "control": "required",
        "attribute": "project",
        "position": "0007",
        "title": "Projekt",
        "type": "project"
      },
      {
        "attribute": "customfield_13420",
        "position": "0008",
        "title": "Kunde (Name)",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "Erforderlich",
            "value": "12887"
          },
          {
            "valuedescription": "Nicht erforderlich",
            "value": "12888"
          },
          {
            "valuedescription": "Wird nachgereicht",
            "value": "12889"
          }
        ],
        "attribute": "customfield_14530",
        "position": "0009",
        "title": "Lokation (GNV)",
        "type": "option"
      },
      {
        "attribute": "customfield_13423",
        "position": "0010",
        "title": "Vertriebler (E-Mail)",
        "type": "string"
      },
      {
        "attribute": "customfield_13422",
        "position": "0011",
        "title": "Vertriebler (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_15501",
        "position": "0012",
        "title": "Salesforce (Source)",
        "type": "string"
      },
      {
        "attribute": "customfield_13700",
        "position": "0013",
        "title": "Lokation (Straße)",
        "type": "string"
      },
      {
        "attribute": "customfield_14413",
        "position": "0014",
        "title": "Lokation (PLZ)",
        "type": "string"
      },
      {
        "attribute": "customfield_13415",
        "position": "0015",
        "title": "Kunde (Firma)",
        "type": "string"
      },
      {
        "attribute": "customfield_14529",
        "position": "0016",
        "title": "Vertragstermin",
        "type": "date"
      },
      {
        "attribute": "customfield_13418",
        "position": "0017",
        "title": "Kunde (Nummer)",
        "type": "string"
      },
      {
        "attribute": "customfield_14901",
        "position": "0018",
        "title": "Auftrag-ID",
        "type": "string"
      },
      {
        "attribute": "customfield_14527",
        "position": "0019",
        "title": "Wunschtermin",
        "type": "date"
      },
      {
        "attribute": "customfield_14604",
        "position": "0020",
        "title": "Lokation (Raum)",
        "type": "string"
      },
      {
        "attribute": "customfield_13419",
        "position": "0021",
        "title": "Kunde (E-Mail)",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "BW",
            "value": "10309"
          },
          {
            "valuedescription": "Hessen",
            "value": "10310"
          },
          {
            "valuedescription": "NRW",
            "value": "10311"
          },
          {
            "valuedescription": "HE",
            "value": "11500"
          },
          {
            "valuedescription": "BB",
            "value": "13216"
          },
          {
            "valuedescription": "BE",
            "value": "13217"
          },
          {
            "valuedescription": "BY",
            "value": "13218"
          },
          {
            "valuedescription": "HB",
            "value": "13219"
          },
          {
            "valuedescription": "HH",
            "value": "13220"
          },
          {
            "valuedescription": "MV",
            "value": "13221"
          },
          {
            "valuedescription": "NI",
            "value": "13222"
          },
          {
            "valuedescription": "RP",
            "value": "13223"
          },
          {
            "valuedescription": "SH",
            "value": "13224"
          },
          {
            "valuedescription": "SL",
            "value": "13225"
          },
          {
            "valuedescription": "SN",
            "value": "13226"
          },
          {
            "valuedescription": "ST",
            "value": "13227"
          },
          {
            "valuedescription": "TH",
            "value": "13228"
          }
        ],
        "attribute": "customfield_10909",
        "position": "0022",
        "title": "Region",
        "type": "option"
      },
      {
        "control": "required",
        "attribute": "summary",
        "position": "0023",
        "title": "Zusammenfassung",
        "type": "string"
      },
      {
        "attribute": "customfield_14582",
        "position": "0024",
        "title": "Kunde (Mobil)",
        "type": "string"
      },
      {
        "attribute": "customfield_14583",
        "position": "0025",
        "title": "Vermittler (Telefon)",
        "type": "string"
      },
      {
        "attribute": "customfield_14581",
        "position": "0026",
        "title": "Kunde (Telefon)",
        "type": "string"
      },
      {
        "attribute": "customfield_13410",
        "position": "0027",
        "title": "Kunde (PLZ)",
        "type": "string"
      },
      {
        "attribute": "customfield_14584",
        "position": "0028",
        "title": "Vermittler (Mobil)",
        "type": "string"
      },
      {
        "attribute": "customfield_14585",
        "position": "0029",
        "title": "Consulting-ID",
        "type": "string"
      },
      {
        "attribute": "customfield_13411",
        "position": "0030",
        "title": "Kunde (Straße)",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "BW",
            "value": "12961"
          },
          {
            "valuedescription": "HE",
            "value": "12962"
          },
          {
            "valuedescription": "NRW",
            "value": "12963"
          },
          {
            "valuedescription": "BB",
            "value": "13203"
          },
          {
            "valuedescription": "BE",
            "value": "13204"
          },
          {
            "valuedescription": "BY",
            "value": "13205"
          },
          {
            "valuedescription": "HB",
            "value": "13206"
          },
          {
            "valuedescription": "HH",
            "value": "13207"
          },
          {
            "valuedescription": "MV",
            "value": "13208"
          },
          {
            "valuedescription": "NI",
            "value": "13209"
          },
          {
            "valuedescription": "RP",
            "value": "13210"
          },
          {
            "valuedescription": "SH",
            "value": "13211"
          },
          {
            "valuedescription": "SL",
            "value": "13212"
          },
          {
            "valuedescription": "SN",
            "value": "13213"
          },
          {
            "valuedescription": "ST",
            "value": "13214"
          },
          {
            "valuedescription": "TH",
            "value": "13215"
          }
        ],
        "attribute": "customfield_14588",
        "position": "0031",
        "title": "Kunde (Region)",
        "type": "option"
      },
      {
        "valuelist": [
          {
            "valuedescription": "Frau",
            "value": "12964"
          },
          {
            "valuedescription": "Herr",
            "value": "12965"
          }
        ],
        "attribute": "customfield_14589",
        "position": "0032",
        "title": "Kunde (Anrede)",
        "type": "option"
      },
      {
        "attribute": "customfield_13702",
        "position": "0033",
        "title": "Lokation (Ort)",
        "type": "string"
      },
      {
        "attribute": "customfield_13801",
        "position": "0034",
        "title": "Vermittler (E-Mail)",
        "type": "string"
      },
      {
        "attribute": "customfield_13800",
        "position": "0035",
        "title": "Vermittler (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_13703",
        "position": "0036",
        "title": "TA-Partner (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_13409",
        "position": "0037",
        "title": "Kunde (Ort)",
        "type": "string"
      },
      {
        "attribute": "customfield_13805",
        "position": "0038",
        "title": "Vermittler (Firma)",
        "type": "string"
      },
      {
        "attribute": "customfield_13807",
        "position": "0039",
        "title": "Gesamtkosten in Euro (OPEX p.a.)",
        "type": "number"
      },
      {
        "attribute": "customfield_13806",
        "position": "0040",
        "title": "Systemkosten in Euro (CAPEX)",
        "type": "number"
      },
      {
        "attribute": "customfield_13809",
        "position": "0041",
        "title": "Gesamtkosten in Euro (CAPEX)",
        "type": "number"
      },
      {
        "attribute": "customfield_13808",
        "position": "0042",
        "title": "Tiefbaukosten in Euro (CAPEX)",
        "type": "number"
      }
    ]
  }
}
