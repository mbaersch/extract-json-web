___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "categories": [
    "UTILITY"
  ],
  "displayName": "Extract From JSON",
  "description": "Extract element from JSON object or valid JSON string by path (using dot-notation). Useful for parsing consent cookie values and other settings without using Custom JS variables",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "obj",
    "displayName": "JSON Input",
    "simpleValueType": true,
    "help": "Variable containing JSON object or valid JSON string",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "TEXT",
    "name": "path",
    "displayName": "Path to Element",
    "simpleValueType": true,
    "help": "Examples: products[0].price, propertyName, property.subProperty",
    "alwaysInSummary": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "stringify",
    "checkboxText": "Convert Object Results to String",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const JSON = require('JSON');

var path = data.path || "";
var obj = data.obj || {};

if (typeof(obj) === "string") obj = JSON.parse(obj); 
 
var res = path.split('.').reduce(function(o, k) {
  var ind = k.indexOf('[');
  var ind2 = k.indexOf(']');
  if (ind >=0 && ind2 > ind) {
    var kOrg = k;
    k = kOrg.substring(0,ind);
    var key = kOrg.substring(ind+1, ind2);
    if (k != "")
      return o && o[k][key];
    else 
      return o && o[key];
  } else return o && o[k];
}, obj);

if ((typeof(res) === "object") && data.stringify) res = JSON.stringify(res);

return res;


___TESTS___

scenarios:
- name: testExtractionAsString1
  code: |-
    let variableResult = runCode(mockData);

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo("objv2Value");
- name: testExtractionAsObject
  code: |-
    mockData.stringify = false;
    mockData.path = 'someObject';

    let variableResult = runCode(mockData);
    //expected result object
    let rs = {"objv1": "objv1Value", "objv2": "objv2Value"};

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo(rs);
- name: testExtractionAsString2
  code: |-
    mockData.path = 'someObject';

    let variableResult = runCode(mockData);
    //expected result string
    let rs = '{"objv1":"objv1Value","objv2":"objv2Value"}';

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo(rs);
- name: testExtractionFromArray
  code: |-
    mockData.path = 'someArray[0].prop1';

    let variableResult = runCode(mockData);
    //expected result string
    let rs = "prop0_1Value";

    // Verify that the variable returns a result.
    assertThat(variableResult).isEqualTo(rs);
setup: |-
  var mockData = {
    obj: '{"something": "someValue", "someObject": {"objv1": "objv1Value", "objv2": "objv2Value"}, "somethingElse": false, "someArray":[{"prop1": "prop0_1Value", "prop2": "prop0_2Value"},{"prop1": "prop1_1Value", "prop2": "prop1_2Value"}]}',
    path: "someObject.objv2",
    stringify: true
  };


___NOTES___

Created on 8.10.2021, 19:24:07


