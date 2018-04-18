{
  "form": {
    "type": "ISSUE",
    "title": "Create Issue",
    "actions": [
      {
        "method": "PUT",
        "source": "https://ker-l-jirapp02t.unity.media.corp/rest/cwx-sol-rest/latest/sol/aob/object/form/issue/bbs/11201",
        "title": "Save ISSUE"
      }
    ],
    "key": "/issue/bbs/11201",
    "attributevalues": [
      {
        "valuelist": [
          {
            "valuedescription": "New Fiber",
            "icon": "https://ker-l-jirapp02t.unity.media.corp/secure/viewavatar?size=xsmall&avatarId=12013&avatarType=issuetype",
            "value": "11201"
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
        "attribute": "customfield_14596",
        "position": "0009",
        "title": "Produkt (Laufzeit)",
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
        "position": "0010",
        "title": "Lokation (GNV)",
        "type": "option"
      },
      {
        "attribute": "customfield_13423",
        "position": "0011",
        "title": "Vertriebler (E-Mail)",
        "type": "string"
      },
      {
        "attribute": "customfield_13422",
        "position": "0012",
        "title": "Vertriebler (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_13700",
        "position": "0013",
        "title": "Lokation (Straße)",
        "type": "string"
      },
      {
        "attribute": "customfield_15501",
        "position": "0014",
        "title": "Salesforce (Source)",
        "type": "string"
      },
      {
        "attribute": "customfield_14413",
        "position": "0015",
        "title": "Lokation (PLZ)",
        "type": "string"
      },
      {
        "attribute": "customfield_13415",
        "position": "0016",
        "title": "Kunde (Firma)",
        "type": "string"
      },
      {
        "attribute": "customfield_14529",
        "position": "0017",
        "title": "Vertragstermin",
        "type": "date"
      },
      {
        "attribute": "customfield_13418",
        "position": "0018",
        "title": "Kunde (Nummer)",
        "type": "string"
      },
      {
        "attribute": "customfield_14603",
        "position": "0019",
        "title": "Preis in Euro (OTC)",
        "type": "number"
      },
      {
        "attribute": "customfield_14527",
        "position": "0020",
        "title": "Wunschtermin",
        "type": "date"
      },
      {
        "attribute": "customfield_14604",
        "position": "0021",
        "title": "Lokation (Raum)",
        "type": "string"
      },
      {
        "attribute": "customfield_14901",
        "position": "0022",
        "title": "Auftrag-ID",
        "type": "string"
      },
      {
        "attribute": "customfield_13419",
        "position": "0023",
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
        "position": "0024",
        "title": "Region",
        "type": "option"
      },
      {
        "control": "required",
        "attribute": "summary",
        "position": "0025",
        "title": "Zusammenfassung",
        "type": "string"
      },
      {
        "attribute": "customfield_14582",
        "position": "0026",
        "title": "Kunde (Mobil)",
        "type": "string"
      },
      {
        "attribute": "customfield_14583",
        "position": "0027",
        "title": "Vermittler (Telefon)",
        "type": "string"
      },
      {
        "attribute": "customfield_14581",
        "position": "0028",
        "title": "Kunde (Telefon)",
        "type": "string"
      },
      {
        "attribute": "customfield_13410",
        "position": "0029",
        "title": "Kunde (PLZ)",
        "type": "string"
      },
      {
        "attribute": "customfield_14584",
        "position": "0030",
        "title": "Vermittler (Mobil)",
        "type": "string"
      },
      {
        "attribute": "customfield_14585",
        "position": "0031",
        "title": "Consulting-ID",
        "type": "string"
      },
      {
        "valuelist": [
          {
            "valuedescription": "Gold",
            "value": "13201"
          },
          {
            "valuedescription": "Platin",
            "value": "13202"
          }
        ],
        "attribute": "customfield_14700",
        "position": "0032",
        "title": "Produkt (SLA)",
        "type": "option"
      },
      {
        "attribute": "customfield_13411",
        "position": "0033",
        "title": "Kunde (Straße)",
        "type": "string"
      },
      {
        "attribute": "customfield_14602",
        "position": "0034",
        "title": "Preis in Euro (MRR)",
        "type": "number"
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
        "position": "0035",
        "title": "Kunde (Region)",
        "type": "option"
      },
      {
        "valuelist": [
          {
            "valuedescription": "MLE/Fiber",
            "children": [
              {
                "valuedescription": "50 Mbit",
                "value": "12840"
              },
              {
                "valuedescription": "100 Mbit",
                "value": "12841"
              },
              {
                "valuedescription": "200 Mbit",
                "value": "12842"
              },
              {
                "valuedescription": "500 Mbit",
                "value": "12843"
              },
              {
                "valuedescription": "> 500 MBit",
                "value": "12844"
              }
            ],
            "value": "12600"
          },
          {
            "valuedescription": "50 Mbit",
            "value": "14800"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14805"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14812"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14845"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14865"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14885"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14905"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14925"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14945"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14965"
          },
          {
            "valuedescription": "15 Mbit/s",
            "value": "14985"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "15041"
          },
          {
            "valuedescription": "Kategorie B",
            "value": "12613"
          },
          {
            "valuedescription": "100 Mbit",
            "value": "14801"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14806"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14826"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14846"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14866"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14886"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14906"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14926"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14946"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14966"
          },
          {
            "valuedescription": "25 Mbit/s",
            "value": "14986"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "15042"
          },
          {
            "valuedescription": "Kategorie C",
            "value": "12626"
          },
          {
            "valuedescription": "200 Mbit",
            "value": "14802"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14807"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14827"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14847"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14867"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14887"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14907"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14927"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14947"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14967"
          },
          {
            "valuedescription": "35 Mbit/s",
            "value": "14987"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "15043"
          },
          {
            "valuedescription": "BGP",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13007"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13021"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13022"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13023"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13024"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13025"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13026"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13027"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13028"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13029"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13030"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13031"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13032"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13033"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13034"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13035"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13036"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13037"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13038"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13039"
              }
            ],
            "value": "12639"
          },
          {
            "valuedescription": "500 Mbit",
            "value": "14803"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14808"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14828"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14848"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14868"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14888"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14908"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14928"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14948"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14968"
          },
          {
            "valuedescription": "50 Mbit/s",
            "value": "14988"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "15044"
          },
          {
            "valuedescription": "IP-Access",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13000"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13001"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13002"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13003"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13004"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13005"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13006"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13008"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13009"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13010"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13011"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13012"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13013"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13014"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13015"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13016"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13017"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13018"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13019"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13020"
              }
            ],
            "value": "12652"
          },
          {
            "valuedescription": "> 500 MBit",
            "value": "14804"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14809"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14829"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14849"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14869"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14889"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14909"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14929"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14949"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14969"
          },
          {
            "valuedescription": "100 Mbit/s",
            "value": "14989"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "15046"
          },
          {
            "valuedescription": "Point-to-Point",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13040"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13041"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13042"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13043"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13044"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13045"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13046"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13047"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13048"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13049"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13050"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13051"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13052"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13053"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13054"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13055"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13056"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13057"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13058"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13059"
              }
            ],
            "value": "12665"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14810"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14830"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14850"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14870"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14890"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14910"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14930"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14950"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14970"
          },
          {
            "valuedescription": "200 Mbit/s",
            "value": "14990"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "15045"
          },
          {
            "valuedescription": "Point-to-Point LGI",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13080"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13081"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13082"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13083"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13084"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13085"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13086"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13087"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13088"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13089"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13090"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13099"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13091"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13092"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13093"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13094"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13095"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13096"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13097"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13098"
              }
            ],
            "value": "12677"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14811"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14831"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14851"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14871"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14891"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14911"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14931"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14951"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14971"
          },
          {
            "valuedescription": "300 Mbit/s",
            "value": "14991"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "15047"
          },
          {
            "valuedescription": "Point-to-Multipoint",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13100"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13101"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13102"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13103"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13104"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13105"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13106"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13107"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13108"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13109"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13110"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13111"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13112"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13113"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13114"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13115"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13116"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13117"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13118"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13119"
              }
            ],
            "value": "12689"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14813"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14832"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14852"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14872"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14892"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14912"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14932"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14952"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14972"
          },
          {
            "valuedescription": "500 Mbit/s",
            "value": "14992"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "15048"
          },
          {
            "valuedescription": "Multipoint-to-Multipoint",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13120"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13121"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13122"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13123"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13124"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13125"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13126"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13127"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13128"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13129"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13130"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13131"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13132"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13133"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13134"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13135"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13136"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13137"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13138"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13139"
              }
            ],
            "value": "12701"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14814"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14833"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14853"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14873"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14893"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14913"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14933"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14953"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14973"
          },
          {
            "valuedescription": "750 Mbit/s",
            "value": "14993"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "15049"
          },
          {
            "valuedescription": "IP Peering (wholesales)",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13140"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13141"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13142"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13143"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13144"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13145"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13146"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13147"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13148"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13149"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13150"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13151"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13152"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13153"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13154"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13155"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13156"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13157"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13158"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13159"
              },
              {
                "valuedescription": "20.000 Mbit/s",
                "value": "13300"
              },
              {
                "valuedescription": "30.000 Mbit/s",
                "value": "13301"
              },
              {
                "valuedescription": "40.000 Mbit/s",
                "value": "13302"
              },
              {
                "valuedescription": "50.000 Mbit/s",
                "value": "13303"
              },
              {
                "valuedescription": "60.000 Mbit/s",
                "value": "13304"
              },
              {
                "valuedescription": "70.000 Mbit/s",
                "value": "13305"
              },
              {
                "valuedescription": "80.000 Mbit/s",
                "value": "13306"
              },
              {
                "valuedescription": "90.000 Mbit/s",
                "value": "13307"
              },
              {
                "valuedescription": "100.000 Mbit/s",
                "value": "13308"
              }
            ],
            "value": "12713"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14815"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14834"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14854"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14874"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14894"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14914"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14934"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14954"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14974"
          },
          {
            "valuedescription": "1.000 Mbit/s",
            "value": "14994"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "15050"
          },
          {
            "valuedescription": "IP Transit (wholesales)",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13060"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13061"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13062"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13063"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13064"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13065"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13066"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13067"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13068"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13069"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13070"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13071"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13072"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13073"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13074"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13075"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13076"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13077"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13078"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13079"
              },
              {
                "valuedescription": "20.000 Mbit/s",
                "value": "13309"
              },
              {
                "valuedescription": "30.000 Mbit/s",
                "value": "13310"
              },
              {
                "valuedescription": "40.000 Mbit/s",
                "value": "13311"
              },
              {
                "valuedescription": "50.000 Mbit/s",
                "value": "13312"
              },
              {
                "valuedescription": "60.000 Mbit/s",
                "value": "13313"
              },
              {
                "valuedescription": "70.000 Mbit/s",
                "value": "13314"
              },
              {
                "valuedescription": "80.000 Mbit/s",
                "value": "13315"
              },
              {
                "valuedescription": "90.000 Mbit/s",
                "value": "13316"
              },
              {
                "valuedescription": "100.000 Mbit/s",
                "value": "13317"
              }
            ],
            "value": "12725"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14816"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14835"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14855"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14875"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14895"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14915"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14935"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14955"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14975"
          },
          {
            "valuedescription": "2.000 Mbit/s",
            "value": "14995"
          },
          {
            "valuedescription": "20.000 Mbit/s",
            "value": "15051"
          },
          {
            "valuedescription": "Point-to-Point (wholesales)",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13160"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13161"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13162"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13163"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13164"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13165"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13166"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13167"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13168"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13169"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13170"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13171"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13172"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13173"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13174"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13175"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13176"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13177"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13178"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13179"
              },
              {
                "valuedescription": "20.000 Mbit/s",
                "value": "13318"
              },
              {
                "valuedescription": "30.000 Mbit/s",
                "value": "13319"
              },
              {
                "valuedescription": "40.000 Mbit/s",
                "value": "13320"
              },
              {
                "valuedescription": "50.000 Mbit/s",
                "value": "13321"
              },
              {
                "valuedescription": "60.000 Mbit/s",
                "value": "13322"
              },
              {
                "valuedescription": "70.000 Mbit/s",
                "value": "13323"
              },
              {
                "valuedescription": "80.000 Mbit/s",
                "value": "13324"
              },
              {
                "valuedescription": "90.000 Mbit/s",
                "value": "13325"
              },
              {
                "valuedescription": "100.000 Mbit/s",
                "value": "13326"
              }
            ],
            "value": "12737"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14817"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14836"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14856"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14876"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14904"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14916"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14936"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14956"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14976"
          },
          {
            "valuedescription": "2.500 Mbit/s",
            "value": "14996"
          },
          {
            "valuedescription": "30.000 Mbit/s",
            "value": "15052"
          },
          {
            "valuedescription": "Point-to-Point international (wholesales)",
            "children": [
              {
                "valuedescription": "15 Mbit/s",
                "value": "13181"
              },
              {
                "valuedescription": "25 Mbit/s",
                "value": "13182"
              },
              {
                "valuedescription": "35 Mbit/s",
                "value": "13183"
              },
              {
                "valuedescription": "50 Mbit/s",
                "value": "13184"
              },
              {
                "valuedescription": "100 Mbit/s",
                "value": "13185"
              },
              {
                "valuedescription": "200 Mbit/s",
                "value": "13186"
              },
              {
                "valuedescription": "300 Mbit/s",
                "value": "13187"
              },
              {
                "valuedescription": "500 Mbit/s",
                "value": "13188"
              },
              {
                "valuedescription": "750 Mbit/s",
                "value": "13189"
              },
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13190"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13191"
              },
              {
                "valuedescription": "2.500 Mbit/s",
                "value": "13192"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13193"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13194"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13195"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13196"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13197"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13198"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13199"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13200"
              },
              {
                "valuedescription": "20.000 Mbit/s",
                "value": "13327"
              },
              {
                "valuedescription": "30.000 Mbit/s",
                "value": "13328"
              },
              {
                "valuedescription": "40.000 Mbit/s",
                "value": "13329"
              },
              {
                "valuedescription": "50.000 Mbit/s",
                "value": "13330"
              },
              {
                "valuedescription": "60.000 Mbit/s",
                "value": "13331"
              },
              {
                "valuedescription": "70.000 Mbit/s",
                "value": "13332"
              },
              {
                "valuedescription": "80.000 Mbit/s",
                "value": "13333"
              },
              {
                "valuedescription": "90.000 Mbit/s",
                "value": "13334"
              },
              {
                "valuedescription": "100.000 Mbit/s",
                "value": "13335"
              }
            ],
            "value": "12749"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14818"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14837"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14857"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14877"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14896"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14917"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14937"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14957"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14977"
          },
          {
            "valuedescription": "3.000 Mbit/s",
            "value": "14997"
          },
          {
            "valuedescription": "40.000 Mbit/s",
            "value": "15053"
          },
          {
            "valuedescription": "NNI (wholesales)",
            "children": [
              {
                "valuedescription": "1.000 Mbit/s",
                "value": "13336"
              },
              {
                "valuedescription": "2.000 Mbit/s",
                "value": "13337"
              },
              {
                "valuedescription": "3.000 Mbit/s",
                "value": "13338"
              },
              {
                "valuedescription": "4.000 Mbit/s",
                "value": "13339"
              },
              {
                "valuedescription": "5.000 Mbit/s",
                "value": "13341"
              },
              {
                "valuedescription": "6.000 Mbit/s",
                "value": "13340"
              },
              {
                "valuedescription": "7.000 Mbit/s",
                "value": "13342"
              },
              {
                "valuedescription": "8.000 Mbit/s",
                "value": "13343"
              },
              {
                "valuedescription": "9.000 Mbit/s",
                "value": "13344"
              },
              {
                "valuedescription": "10.000 Mbit/s",
                "value": "13345"
              },
              {
                "valuedescription": "20.000 Mbit/s",
                "value": "13346"
              },
              {
                "valuedescription": "30.000 Mbit/s",
                "value": "13347"
              },
              {
                "valuedescription": "40.000 Mbit/s",
                "value": "13348"
              },
              {
                "valuedescription": "50.000 Mbit/s",
                "value": "13349"
              },
              {
                "valuedescription": "60.000 Mbit/s",
                "value": "13350"
              },
              {
                "valuedescription": "70.000 Mbit/s",
                "value": "13351"
              },
              {
                "valuedescription": "80.000 Mbit/s",
                "value": "13352"
              },
              {
                "valuedescription": "90.000 Mbit/s",
                "value": "13353"
              },
              {
                "valuedescription": "100.000 Mbit/s",
                "value": "13354"
              }
            ],
            "value": "12761"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14819"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14838"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14858"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14878"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14897"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14918"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14938"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14958"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14978"
          },
          {
            "valuedescription": "4.000 Mbit/s",
            "value": "14998"
          },
          {
            "valuedescription": "50.000 Mbit/s",
            "value": "15054"
          },
          {
            "valuedescription": "Darkfiber",
            "value": "12773"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14820"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14839"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14859"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14879"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14898"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14919"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14939"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14959"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14979"
          },
          {
            "valuedescription": "5.000 Mbit/s",
            "value": "14999"
          },
          {
            "valuedescription": "60.000 Mbit/s",
            "value": "15055"
          },
          {
            "valuedescription": "MWS (SME)",
            "value": "14400"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14821"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14840"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14860"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14880"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14899"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14920"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14940"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14960"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "14980"
          },
          {
            "valuedescription": "6.000 Mbit/s",
            "value": "15000"
          },
          {
            "valuedescription": "70.000 Mbit/s",
            "value": "15056"
          },
          {
            "valuedescription": "MWS (wholesales)",
            "value": "14401"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14822"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14841"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14861"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14881"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14900"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14921"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14941"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14961"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "14981"
          },
          {
            "valuedescription": "7.000 Mbit/s",
            "value": "15001"
          },
          {
            "valuedescription": "80.000 Mbit/s",
            "value": "15057"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14823"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14842"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14862"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14882"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14901"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14922"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14942"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14962"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "14982"
          },
          {
            "valuedescription": "8.000 Mbit/s",
            "value": "15002"
          },
          {
            "valuedescription": "90.000 Mbit/s",
            "value": "15058"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14824"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14843"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14863"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14883"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14902"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14923"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14943"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14963"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "14983"
          },
          {
            "valuedescription": "9.000 Mbit/s",
            "value": "15003"
          },
          {
            "valuedescription": "100.000 Mbit/s",
            "value": "15059"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14825"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14844"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14864"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14884"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14903"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14924"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14944"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14964"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "14984"
          },
          {
            "valuedescription": "10.000 Mbit/s",
            "value": "15004"
          },
          {
            "valuedescription": "20.000 Mbit/s",
            "value": "15005"
          },
          {
            "valuedescription": "20.000 Mbit/s",
            "value": "15014"
          },
          {
            "valuedescription": "20.000 Mbit/s",
            "value": "15023"
          },
          {
            "valuedescription": "20.000 Mbit/s",
            "value": "15032"
          },
          {
            "valuedescription": "30.000 Mbit/s",
            "value": "15006"
          },
          {
            "valuedescription": "30.000 Mbit/s",
            "value": "15015"
          },
          {
            "valuedescription": "30.000 Mbit/s",
            "value": "15024"
          },
          {
            "valuedescription": "30.000 Mbit/s",
            "value": "15033"
          },
          {
            "valuedescription": "40.000 Mbit/s",
            "value": "15007"
          },
          {
            "valuedescription": "40.000 Mbit/s",
            "value": "15016"
          },
          {
            "valuedescription": "40.000 Mbit/s",
            "value": "15025"
          },
          {
            "valuedescription": "40.000 Mbit/s",
            "value": "15034"
          },
          {
            "valuedescription": "50.000 Mbit/s",
            "value": "15008"
          },
          {
            "valuedescription": "50.000 Mbit/s",
            "value": "15017"
          },
          {
            "valuedescription": "50.000 Mbit/s",
            "value": "15026"
          },
          {
            "valuedescription": "50.000 Mbit/s",
            "value": "15035"
          },
          {
            "valuedescription": "60.000 Mbit/s",
            "value": "15009"
          },
          {
            "valuedescription": "60.000 Mbit/s",
            "value": "15018"
          },
          {
            "valuedescription": "60.000 Mbit/s",
            "value": "15027"
          },
          {
            "valuedescription": "60.000 Mbit/s",
            "value": "15036"
          },
          {
            "valuedescription": "70.000 Mbit/s",
            "value": "15010"
          },
          {
            "valuedescription": "70.000 Mbit/s",
            "value": "15019"
          },
          {
            "valuedescription": "70.000 Mbit/s",
            "value": "15028"
          },
          {
            "valuedescription": "70.000 Mbit/s",
            "value": "15037"
          },
          {
            "valuedescription": "80.000 Mbit/s",
            "value": "15011"
          },
          {
            "valuedescription": "80.000 Mbit/s",
            "value": "15020"
          },
          {
            "valuedescription": "80.000 Mbit/s",
            "value": "15029"
          },
          {
            "valuedescription": "80.000 Mbit/s",
            "value": "15038"
          },
          {
            "valuedescription": "90.000 Mbit/s",
            "value": "15012"
          },
          {
            "valuedescription": "90.000 Mbit/s",
            "value": "15021"
          },
          {
            "valuedescription": "90.000 Mbit/s",
            "value": "15030"
          },
          {
            "valuedescription": "90.000 Mbit/s",
            "value": "15039"
          },
          {
            "valuedescription": "100.000 Mbit/s",
            "value": "15013"
          },
          {
            "valuedescription": "100.000 Mbit/s",
            "value": "15022"
          },
          {
            "valuedescription": "100.000 Mbit/s",
            "value": "15031"
          },
          {
            "valuedescription": "100.000 Mbit/s",
            "value": "15040"
          }
        ],
        "attribute": "customfield_14500",
        "position": "0036",
        "title": "Produkt",
        "type": "option-with-child"
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
        "position": "0037",
        "title": "Kunde (Anrede)",
        "type": "option"
      },
      {
        "attribute": "customfield_13702",
        "position": "0038",
        "title": "Lokation (Ort)",
        "type": "string"
      },
      {
        "attribute": "customfield_13801",
        "position": "0039",
        "title": "Vermittler (E-Mail)",
        "type": "string"
      },
      {
        "attribute": "customfield_13800",
        "position": "0040",
        "title": "Vermittler (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_13703",
        "position": "0041",
        "title": "TA-Partner (Name)",
        "type": "string"
      },
      {
        "attribute": "customfield_13409",
        "position": "0042",
        "title": "Kunde (Ort)",
        "type": "string"
      },
      {
        "attribute": "customfield_13805",
        "position": "0043",
        "title": "Vermittler (Firma)",
        "type": "string"
      },
      {
        "attribute": "customfield_13807",
        "position": "0044",
        "title": "Gesamtkosten in Euro (OPEX p.a.)",
        "type": "number"
      },
      {
        "attribute": "customfield_13806",
        "position": "0045",
        "title": "Systemkosten in Euro (CAPEX)",
        "type": "number"
      },
      {
        "attribute": "customfield_13809",
        "position": "0046",
        "title": "Gesamtkosten in Euro (CAPEX)",
        "type": "number"
      },
      {
        "attribute": "customfield_13808",
        "position": "0047",
        "title": "Tiefbaukosten in Euro (CAPEX)",
        "type": "number"
      }
    ]
  }
}