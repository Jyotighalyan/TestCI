//'use strict';
//# sourceURL=csa_pmwidget.js;

// Custom implementation if the display handler for Text Display Attribute Type.
// It is copied from the current cscfga implementation.
// Disables configurator from overriding the custom set html (with a JS action)
// to a Text Display attribute.
console.warn("Overriding default Configurator display handler for 'Text Display' Attribute Type");
CS.DataBinder.registerHandler(CS.UI.TEXT_DISPLAY, (function UI_TextDisplay() {
    // An array of attributes for which the configurator engine should
    // not overwrite the custom html
    var ATTRS_TO_SKIP = ['PMWidget_0'];
    var csBindingName;
	var prefix = CS.Util.configuratorPrefix;
	return {
		name: 'Text Display',

		onChange: function() {
			// no-op
		},

		updateUI: function(binding, triggerEvent) {
			var displayHandler = {
				updateDisplay: function(element, value, displayValue) {

                    csBindingName = jQuery(element).data('csBinding');
					if (typeof csBindingName == 'string' && _.contains(ATTRS_TO_SKIP, csBindingName)) {
						var html = jQuery(element).html();
						if(html === "" || html == '&nbsp;') {
							jQuery(element).html(value);
						} else {
						    console.warn("Skipping updateDisplay method execution for " + csBindingName);
						}
					} else {
						jQuery(element).html(value);
					}
				},

				markRequired: CS.UI.Effects.markRequired
			};

			CS.UI.Effects.processEffects(binding, displayHandler);

			if (triggerEvent) el.change();

		},

		updateAttribute: function(wrapper, properties) {
			if (properties.hasOwnProperty('value')) {
				properties.displayValue = CS.DataConverter.localizeValue(
					properties.value,
					{
						type: wrapper.definition[prefix + 'Data_Type__c'],
						scale: wrapper.definition[prefix + 'Scale__c']
					}
				);
			}
			CS.DataBinder.applyProperties(wrapper, properties);
		}
	};
})(), true);


// ES6 Promise polyfill for IE
!function(e){function n(){}function t(e,n){return function(){e.apply(n,arguments)}}function o(e){if("object"!=typeof this)throw new TypeError("Promises must be constructed via new");if("function"!=typeof e)throw new TypeError("not a function");this._state=0,this._handled=!1,this._value=void 0,this._deferreds=[],s(e,this)}function i(e,n){for(;3===e._state;)e=e._value;return 0===e._state?void e._deferreds.push(n):(e._handled=!0,void o._immediateFn(function(){var t=1===e._state?n.onFulfilled:n.onRejected;if(null===t)return void(1===e._state?r:u)(n.promise,e._value);var o;try{o=t(e._value)}catch(i){return void u(n.promise,i)}r(n.promise,o)}))}function r(e,n){try{if(n===e)throw new TypeError("A promise cannot be resolved with itself.");if(n&&("object"==typeof n||"function"==typeof n)){var i=n.then;if(n instanceof o)return e._state=3,e._value=n,void f(e);if("function"==typeof i)return void s(t(i,n),e)}e._state=1,e._value=n,f(e)}catch(r){u(e,r)}}function u(e,n){e._state=2,e._value=n,f(e)}function f(e){2===e._state&&0===e._deferreds.length&&o._immediateFn(function(){e._handled||o._unhandledRejectionFn(e._value)});for(var n=0,t=e._deferreds.length;n<t;n++)i(e,e._deferreds[n]);e._deferreds=null}function c(e,n,t){this.onFulfilled="function"==typeof e?e:null,this.onRejected="function"==typeof n?n:null,this.promise=t}function s(e,n){var t=!1;try{e(function(e){t||(t=!0,r(n,e))},function(e){t||(t=!0,u(n,e))})}catch(o){if(t)return;t=!0,u(n,o)}}var a=setTimeout;o.prototype["catch"]=function(e){return this.then(null,e)},o.prototype.then=function(e,t){var o=new this.constructor(n);return i(this,new c(e,t,o)),o},o.all=function(e){var n=Array.prototype.slice.call(e);return new o(function(e,t){function o(r,u){try{if(u&&("object"==typeof u||"function"==typeof u)){var f=u.then;if("function"==typeof f)return void f.call(u,function(e){o(r,e)},t)}n[r]=u,0===--i&&e(n)}catch(c){t(c)}}if(0===n.length)return e([]);for(var i=n.length,r=0;r<n.length;r++)o(r,n[r])})},o.resolve=function(e){return e&&"object"==typeof e&&e.constructor===o?e:new o(function(n){n(e)})},o.reject=function(e){return new o(function(n,t){t(e)})},o.race=function(e){return new o(function(n,t){for(var o=0,i=e.length;o<i;o++)e[o].then(n,t)})},o._immediateFn="function"==typeof setImmediate&&function(e){setImmediate(e)}||function(e){a(e,0)},o._unhandledRejectionFn=function(e){"undefined"!=typeof console&&console&&console.warn("Possible Unhandled Promise Rejection:",e)},o._setImmediateFn=function(e){o._immediateFn=e},o._setUnhandledRejectionFn=function(e){o._unhandledRejectionFn=e},"undefined"!=typeof module&&module.exports?module.exports=o:e.Promise||(e.Promise=o)}(this);

require(['cs-full'], function(CS) {
	var ROOT_REFERENCE = '';
	var emptyPromise = Promise.resolve();
	var rulesFunction;
	var lookupPromise = Promise.resolve();

	var configAttrCache = {};
	var priceItemAttrCache = {};
	var onChangeHandlers = {};
	var handlersBound = false;
	var lookupDeletePollerInterval;
	
	// This variable holds the reference of the 
	// attribute whose change changes the 
	// price item attribute.
	var selectListAttr = 'Product_Type_0';
	var selectListAttrDigitalTv = 'Activation_Type_0'; // only Digital TV product
	
	// A decorator method of the configurationController hook
	// method "initializeProduct". Used to set the flag
	// "handlersBound" to false to ensure that the bindings
	// in "runCompatibilityFunctionsModel2" method are bound
	// every time a new product configuration process is started.
	var ccd = CS.App.getController('configuration').delegate;
	var initProduct = ccd.hooks.initializeProduct; 
	ccd.hooks.initializeProduct = function() {
		configAttrCache = {};
		priceItemAttrCache = {};
		onChangeHandlers = {};
		handlersBound = false;
		initProduct.apply(this, arguments);
	};

	/*
	 * Custom JavaScript action enforcing the Pricing Model behaviours implemented by the Elastic API.
	 */
	function buildCompatibilityFunctions() {

		/*
		 * runCompatibilityFunctions
		 *
		 * Provides Configurator behaviour for the Pricing Model consistent with rules
		 * implemented in Elastic API
		 */
		function runCompatibilityFunctionsModel2() {
			if (!handlersBound) {
				CS.binding.on('beforeupdate', beforeUpdateHandler);
				CS.binding.on('afterupdate', afterUpdateHandler);
				handlersBound = true;
			}

			// Commented out because the product definitions do not contain
			// a lookup attribute which changes the price item attribute.
			// Instead a select list change triggers calculations (or rules)
			// which change the value.
			
			//var priceItemAttr = findPriceItemAttributeForConfigRef(ROOT_REFERENCE);
			//registerOnChangeHandler(priceItemAttr.reference, priceItemOnChangeHandler);

			registerOnChangeHandler(selectListAttr, priceItemOnChangeHandler);

			registerOnChangeHandler(selectListAttrDigitalTv, priceItemOnChangeHandler);
			
			// Commented out - the functionality invoked here is also invoked 
			// in the "priceItemOnChangeHandler". There is no need to invoke it
			// again and have duplicate addons.
			/*
			return addDefaultAddOns(ROOT_REFERENCE)
			.catch(function(e) {
				console.error('EAPI Compatibility: error adding default Add Ons', e);
			})
			.then(function() {
				setConfigurationNames();
				setPrices();
				setLineItemDescriptions();
			})
			.catch(function(e) {
				console.error('EAPI Compatibility: error running compatibility functions', e);
			});
			*/
		}

		/*
		 * addDefaultAddOns
		 *
		 * When a Price Item-based product is first added to the basket, assess for default
		 * Add Ons and if found, add the default Add Ons automatically.
		 *
		 * Since there is no 'add to basket' in the regular Configurator, a newly added
		 * product is identified through a 'first run' Attribute used to flag whether this
		 * logic has been performed for this configuration.
		 */
		function addDefaultAddOns(configRef) {

			function chainAddDefaultAddons(promise, attr) {
				return promise.then(function() {
					return addDefaultAddOnsForAttribute(attr);
				});
			}

			return getPriceItemForConfig(configRef)
			.then(function(priceItem) {
				if (!priceItem) {
					console.info('EAPI compatibility: Skipping addDefaultAddOns – no Price Item selected');
					return emptyPromise;
				}

				if (productIsNewlyAddedToBasket(configRef)) {
					console.log('EAPI compatibility: adding default Add Ons');
					return findAddOnRelatedProductAttributes(configRef, priceItem);
				} else {
					console.info('Skipping addDefaultAddOns – first run complete');
					return emptyPromise;
				}
			})
			.then(function(attrList) {
				return _.reduce(attrList, chainAddDefaultAddons, emptyPromise);
			});

		}

		/*
		 * displayPricingWidget
		 *
		 * Displays the pricing widget table for the specified configuration referenece
		 * in the HTML element identified by containerSelector (default = '.pmWidget').
		 *
		 * The HTML is currently hardcoded – but an enhancement would be to provide
		 * a mechanism for supplying templates.
		 */
		function displayPricingWidget(configRef, containerSelector) {
			var relatedProductAttrs;
			var selector = containerSelector || '.pmWidget';
			return findAddOnRelatedProductAttributes(configRef)
			.then(function(attrs) {
				relatedProductAttrs = attrs;
				hideControlButtons(attrs);
			})
			.then(function() {
				return getPriceItemForConfig(configRef);
			})
			.then(function(priceItem) {
				if (!priceItem) {
					console.info('EAPI compatibility: Clearing displayPricingWidget – no Price Item selected');
					jQuery(selector).html('');
					return emptyPromise;
				}
				return buildPricingWidget(relatedProductAttrs, selector);
			});
		}

		/*
		 * buildPricingWidget
		 *
		 * Used by displayPricingWidget to build the widget HTML populated with the
		 * add ons for the supplied related product attributes list
		 */
		function buildPricingWidget(attrs, selector) {
			var table = jQuery('<table style="background: #fff; border-collapse: collapse; width: 690px">'
				+ '<tr style="font-size: 12px; color: gray">'
				+ '<th style="padding-left: 6px; padding-right: 6px; padding-top: 2px"></th>'
				+ '<th style="padding-right: 6px; padding-top: 2px"></th>'
				// + '<th style="padding-right: 6px; padding-top: 8px">Group</th>'
				+ '<th style="padding-right: 6px; padding-top: 2px; text-align: right">Monatliche<br />Entgelte</th>'
				+ '<th style="padding-right: 6px; padding-top: 2px; text-align: right">Bereitstellung-<br />sentgelte</th>'
				// + '<th style="padding-top: 8px">Message</th>'
				+ '</tr>'
				+ '</table>');
			return _.reduce(attrs, buildPricingWidgetSectionForAttr, Promise.resolve(table))
			.then(function(table) {
				jQuery(selector).html(table);
			}).catch(function(err) {
				console.error('EAPI compatibility: cannot display pricing widget.', err);
				return Promise.reject(err);
			});
		}

		/*
		 * buildPricingWidgetSectionForAttr
		 *
		 * Used by buildPricingWidget to contruct the table section for the supplied
		 * related product attribute, chained to the supplied promise.
		 */
		function buildPricingWidgetSectionForAttr(promise, attr) {
			return promise.then(function(table) {
				//var headerRow = jQuery('<tr><th style="background: #ddd; padding: 6px" colspan="6">Related Product: ' + (attr.attr.cscfga__Label__c || attr.attr.Name) + '</th></tr>');
				//table.append(headerRow);
				return getAddOnAssociationsListForAttr(attr)
				.then(function(assocs) {
					var currentlySelectedAddOnIds = getSelectedAddOnIds(attr);
					return buildAddOnListWithGroupAndCardinalityConstraints(assocs, currentlySelectedAddOnIds);
				})
				.then(function(addOns) {

					addOns.sort(function(a, b) {
					    var descA = a.assoc.description__c ? a.assoc.description__c.toUpperCase() : '';
					    var descB = b.assoc.description__c ? b.assoc.description__c.toUpperCase() : '';
					    return (descA < descB) ? -1 : (descA > descB) ? 1 : 0;
					});

					_.each(addOns, function(it) {
						if (it.assoc.description__c) // if decription exists, add row
						{
							var row = '<tr>'
								+ '<td style="padding: 6px;"><a href="#" onclick="CS.EAPI.insertAddOn(\'' + attr.reference + '\',\'' + it.assoc.id + '\')">' + (it.isAvailable ? 'Add' : '') + '</a></td>'
								+ '<td style="padding: 6px">' + it.assoc.description__c + '</td>'
								// + '<td style="padding: 6px">' + it.assoc.cspmb__group__c + '</td>'
								+ '<td style="text-align: right; padding: 6px">' + asDecimal(it.assoc.cspmb__recurring_charge__c, 2).toString().replace(".", ",") + '</td>'
								+ '<td style="text-align: right; padding: 6px">' + asDecimal(it.assoc.cspmb__one_off_charge__c, 2).toString().replace(".", ",") + '</td>'
								// + '<td style="padding: 6px">' + (it.isAvailable ? '' : it.unavailableReason) + '</td>'
								+ '</tr>';
							table.append(row);
						}
					});
					return table;
				});
			});
		}

		/*
		 * insertAddOn
		 *
		 * Inserts an instance of the Add On identified by addOnId into the
		 * Related Product attribute identified by attrRef.
		 */
		function insertAddOn(attrRef, addOnId) {
			return createRelatedProducts({ reference: attrRef }, [{ id: addOnId }]);
		}

		/*
		 * setConfigurationNames
		 *
		 * Sets names of configurations in the model where an Attribute Field named '__ConfigName__' on the
		 * Lookup Attribute linked to the Pricing Model provides an expression indicating the lookup field value to use.
		 */
		function setConfigurationNames() {
			var pricingModelLookups = getPricingModelLookupAttributes();
			var lookups = _.filter(pricingModelLookups, function(it) { return !!it.attributeFields.__ConfigName__; });
			_.each(lookups, function(it) {
				var ref = CS.Util.getAnchorReference(CS.Util.getParentReference(it.reference));
				var wrapper = CS.getConfigurationWrapper(ref);
				_.each(wrapper.relatedProducts, function(rp) {
					var reference = it.reference.replace(ref, rp.reference);
					var name = resolveLookupValue(it.attributeFields.__ConfigName__.cscfga__Value__c, reference);
					var parent = CS.Util.getParentReference(reference);
					CS.setConfigurationProperty(parent, 'name', name);
					console.log('EAPI compatibility: Set configuration name for \'' + parent + '\' to: ' + name);
				})
				_.each(CS.binding.getBindings(ref), function(binding) {
					binding.handler.updateUI(binding);
				});
			});
		}

		/*
		 * setPrices
		 *
		 * Sets attribute prices. For any Attribute with an Attribute Field named '__Price__', uses the expression value
		 * to find the Pricing Model lookup field used to set price on that Attribute.
		 */
		function setPrices() {
			var pricingAttrs = _.filter(CS.Service.config, function(it) { return it.attr && it.attributeFields.__Price__; });
			_.each(pricingAttrs, function(it) {
				var af = it.attributeFields.__Price__.cscfga__Value__c;
				var lkVal = resolveLookupValue(af, it.reference);
				CS.setAttributeField(it.reference, 'price', lkVal);
				console.log('EAPI compatibility: Set price of ' + it.reference + ' to: ' + lkVal);
				if (lkVal == null) {
					CS.setAttributeField(it.reference, 'islineitem', false);
				}
			});
		}

		/*
		 * setLineItemDescriptions
		 *
		 * For all line item attributes, where the line item description field contains a Pricing Model lookup
		 * expression, set the line item description to the resolved field value.
		 */
		function setLineItemDescriptions() {
			var pricingModelLookups = getPricingModelLookupAttributes();
			var lineItems = _.filter(CS.Service.config, function(it) { return it.attr && it.attr.cscfga__Is_Line_Item__c; });
			_.each(lineItems, function(it) {
				var lkVal = resolveLookupValue(it.definition.cscfga__Line_Item_Description__c, it.reference);
				if (lkVal) {
					CS.getAttributeFieldValue(it.reference, 'lineitemdescription', lkVal);
					console.log('EAPI compatibility: Set line item description for ' + it.reference + ' to: ' + lkVal);
				}
			});
		}

		/*
		 * addDefaultAddOnsForAttribute
		 *
		 * Finds the default add ons, if any, (i.e. the add ons which have a default quantity specified)
		 * for the given related product attribute.
		 */
		function addDefaultAddOnsForAttribute(attr) {
			return getAddOnAssociationsListForAttr(attr)
			.then(filterAddOnAssociationsByDefaultQuantity)
			.then(function(addOns) {
				return createRelatedProducts(attr, addOns);
			});
		}

		/*
		 * getAddOnAssociationsListForAttr
		 *
		 * Finds the default add ons, if any, (i.e. the add ons which have a default quantity specified)
		 * for the given related product attribute.
		 */
		function getAddOnAssociationsListForAttr(attWrapper) {
			var configRef = CS.Util.getParentReference(attWrapper.reference);
			var prefix = configRef ? configRef + ':' : '';
			var regExp = new RegExp('^' + prefix + '[^:]+$');
			var index = CS.Service.getProductIndex(configRef);
			var attrDef = index.all[attWrapper.definitionId];
			var productDefinitionId = CS.getConfigurationWrapper(configRef).config.cscfga__Product_Definition__c;
			var filterAttrNames;
			var filterAttrs = {};

			if (!attrDef) {
				console.warn('Could not find attribute definition id for attr ', attWrapper);
				return Promise.reject('Could not find attribute definition id for attr ' + attWrapper.reference);
			}
			var lc = index.all[attrDef.cscfga__Lookup_Config__c];
			if (!lc) {
				return Promise.reject('LookupConfig could not be found for attr ' + attWrapper.reference);
			}

			var lq = index.all[lc.cscfga__Filter__c];
			if (!lq) {
				return Promise.reject('LookupQuery filter could not be found for attr ' + attWrapper.reference);
			}

			if (lq.cscfga__Referenced_Attributes__c) {
				try {
					filterAttrNames = JSON.parse(lq.cscfga__Referenced_Attributes__c);
				} catch (e) {
					console.error('Could not parse referenced Attributes: ' + lq.Id + ' / ' + lq.cscfga__Referenced_Attributes__c);
				}
			} else {
				filterAttrNames = [];
			}

			_.each(CS.Service.config, function(node) {
				if (node.attr && regExp.exec(node.reference)) {
					var name = node.attr.Name;
					if (_.indexOf(filterAttrNames, name) > -1) {
						var val = node.attr.cscfga__Value__c;
						var isIdRegExp = /^([a-zA-Z0-9]{15})$/g;
						if (isIdRegExp.test(val)) {
							val = generate18CharId(val);
						}
						filterAttrs[name] = val;
					}
				}
			});

			return doLookupQuery(lq.Name, filterAttrs, productDefinitionId);
		}

		/*
		 * findAddOnRelatedProductAttributes
		 *
		 * Returns a Promise providing a list of add-on related product attributes in the specified config.
		 * Add-on related product attributes have the following characteristics:
		 *
		 * 	1. A single 'avaialble product definition'
		 * 	2. That product definition contains a lookup attribute with an attribute field named '__AddOnGenerator__'
		 *
		 */
		function findAddOnRelatedProductAttributes(configRef) {
			function addOnGeneratorLookupsFilter(index, configAttrs) {
				return function(avail) {
					var index = CS.Service.getProductIndex(avail.cscfga__Product_Definition__c); 
					var rpAttrs = index.attributeDefsByProduct[avail.cscfga__Product_Definition__c];
					if (!rpAttrs) {
						console.error('Could not find attribute definitions for product definition: ', avail.cscfga__Product_Definition__c);
					}

					var addOnGenerators = _.filter(
						_.where(rpAttrs, { cscfga__Type__c: 'Lookup' }),
						function(it) {
							return _.where(index.attributeFieldDefsByAttributeDef[it.Id], { Name: '__AddonGenerator__' }).length;
						}
					);

					if (addOnGenerators.length) {
						return _.filter(configAttrs, function(it) {
							return it.definitionId === avail.cscfga__Attribute_Definition__c;
						});
					}
				}
			}

			function findAddOnGeneratorLookups(configRef, products, index) {
				var configAttrs = getAttributesForConfigRef(configRef);
				var productsMap = _.map(products, addOnGeneratorLookupsFilter(index, configAttrs));
				var filteredMap = _.filter(productsMap, removeUndefinedFilter);
				var flattenedMap = _.flatten(filteredMap);
				return flattenedMap;
			}

			function loadProductReducer(promise, avail) {
				var defId = avail.cscfga__Product_Definition__c;
				return (!!defId && !CS.Service.getProductIndex(defId))
					? promise.then(function() {
					return loadProduct(defId);
				})
					: promise;
			}

			function removeUndefinedFilter(it) {
				return !!it;
			}

			var index = CS.Service.getProductIndex(configRef);
			var currentProdDefId = CS.getConfigurationWrapper(configRef).config.cscfga__Product_Definition__c;

			var singleAvailableProducts = _.flatten(_.filter(
				_.where(index.availableProductsByAttributeDef, { length: 1 }),
				attributesForProductFilter(currentProdDefId, index)
			));

			var loadProductsPromise = _.reduce(singleAvailableProducts, loadProductReducer, emptyPromise);

			return loadProductsPromise.then(function() {
				return findAddOnGeneratorLookups(configRef, singleAvailableProducts, index);
			});
		}

		/*
		 * findPriceItemAttributeForConfigRef
		 *
		 * Returns the Attribute containing the Price Item for this Config.
		 * This is identified by the presence of a __PriceItemReference__ marker AttributeField
		 */
		function findPriceItemAttributeForConfigRef(ref) {
			var pi = priceItemAttrCache[ref];
			if (pi) {
				return pi;
			}

			var pis = _.filter(CS.Service.config, function(wrapper, reference) {
				return (wrapper.attributeFields
				&& wrapper.attributeFields.__PriceItemReference__
				&& CS.Util.getParentReference(reference) === ref);
			});

			if (pis.length > 1) {
				console.warn('Multiple __PriceItemReference__ markers found, model is invalid: ', pis);
			}

			priceItemAttrCache[ref] = pis[0];

			return pis[0];
		}

		function getPriceItemForConfig(ref) {
			var piAttr = findPriceItemAttributeForConfigRef(ref);
			if (!piAttr) {
				console.log('EAPI compatibility: No price item attribute found in config ref \'' + ref + '\'');
			}
			var priceItem = CS.getAttributeValue(piAttr.reference);
			if (!priceItem) {
				console.log('EAPI compatibility: No price item found in attribute ref ' + piAttr.reference);
			}
			return Promise.resolve(priceItem);
		}

		function buildAddOnListWithGroupAndCardinalityConstraints(assocs, selectedAddOnIds) {
			var groups = buildAssociationGroups(assocs);
			var groupCounts = getAssociationGroupCounts(assocs, groups, selectedAddOnIds);
			return _.map(assocs, function(assoc) {
				var grp = groups[assoc.cspmb__group__c];
				var max = grp[assoc.cspmb__add_on_price_item__c];
				var count = groupCounts[assoc.cspmb__group__c];
				var isAvailable = true;
				var reason;

				if (count + 1 > max) {
					isAvailable = false;
					reason = 'There ' + (count === 1 ? 'is' : 'are') + ' already ' + count + ' of this type of add on selected.';
				}

				return { assoc: assoc, isAvailable: isAvailable, unavailableReason: reason };
			});
			return addOns;
		}

		function filterAddOnAssociationsByDefaultQuantity(assocs) {
			return _.filter(assocs, function(assoc) {
				return assoc.cspmb__default_quantity__c > 0;
			});
		}

		/**** Remote callouts ****/
/*
		function doLookupQuery(name, dynamicFilterMap, productDefinitionId) {
			return new Promise(function(resolve, reject) {
				Visualforce.remoting.Manager.invokeAction(
					'cscfga.UISupport.doMultiRowLookupQuery',
					name,
					dynamicFilterMap,
					productDefinitionId,
					function(result, event) {
						if (event.status) {
							resolve(keysToLowerCase(result));
						} else {
							console.error(event);
							reject(event);
						}
					},
					{ escape: false }
				);
			});
		}
*/
/*
		function loadLookupRecord(params) {
			lookupPromise = lookupPromise.then(function() {
				return new Promise(function(resolve, reject) {
					Visualforce.remoting.Manager.invokeAction(
						'cscfga.UISupport.loadLookupRecord',
						params,
						function(result, event) {
							if (event.status) {
								resolve(result);
							} else {
								console.error(event);
								reject(event);
							}
						},
						{ escape: false }
					);
				});
			});
			return lookupPromise;
		}
*/

		function doLookupQuery(name, dynamicFilterMap, productDefinitionId) {
			name = 'Lookup(' + name + ')';
			return new Promise(function(resolve, reject) {
				return CS.configurationDelegate.lookupQuery(name, dynamicFilterMap, productDefinitionId, function(result) {
					for (var i = 0; i < result.length; i++) {
						result[i] = objPropToLowerCase(result[i]);
					}
					resolve(result);
				}, {multiRowQuery: true});
			});
		}

		function loadLookupRecord(params) {
			function getLookupConfigSobjectName(lookupConfig) {
			    var index = CS.Service.getProductIndex();
			    var prefix = CS.Util.configuratorPrefix;
			    var sObjectName;
			    if (lookupConfig[prefix + 'Object__c']) {
			      sObjectName = lookupConfig[prefix + 'Object__c'];
			    } else {
			      var objectMapping = _.findWhere(index.objectMappingsByName, { Id: lookupConfig[prefix + 'Search_Columns__c'] });
			      if (objectMapping) {
			        sObjectName = objectMapping[prefix + 'From_Type__c'];
			      }
			    }
			    return sObjectName;
			}

			params = typeof params == 'string' ? JSON.parse(params) : params;
			var index = CS.Service.getProductIndex();
			var lookupConfig = index.all[params.attributeLookupConfigId];
			var sObjectName = getLookupConfigSobjectName(lookupConfig);

			lookupPromise = lookupPromise.then(function() {
				return CS.DB.getById(sObjectName, params.attributeValue).then(function(result) {
			    	var retObj= {};
			    	retObj[params.attributeValue] = result;
			    	//retObj['columnMap'] = getSearchMappings() // TODO: check if this is necessary at all
			    	return retObj;
			  	});	
			});
			
			return lookupPromise;
		}

		/**** Utility functions ****/

		function objPropToLowerCase(obj) {
			var key, keys = Object.keys(obj);
			var n = keys.length;
			var newobj={};

			while (n--) {
			  key = keys[n];
			  newobj[key.toLowerCase()] = obj[key];
			}

			return newobj;
		}

		function attributesForProductFilter(productId, index) {
			return function(it) {
				var attrDef = index.all[it[0].cscfga__Attribute_Definition__c];
				return attrDef
					&& attrDef.cscfga__Product_Definition__c == productId
					&& !!it[0].cscfga__Product_Definition__c;
			};
		}

		function getAddOnAttributes() {
			return _.filter(CS.Service.config, function(it) {
				return it.attributeFields && it.attributeFields.__AddOn__
			});
		}

		function getAttributesForConfigRef(ref) {
			var prefix = ref ? ref + ':' : '';
			var regExp = new RegExp('^' + prefix + '[^:]+$');
			var cached = configAttrCache[ref];

			if (cached) {
				return cached;
			}

			return configAttrCache[ref] = _.filter(CS.Service.config, function(node) {
				return node.attr && regExp.exec(node.reference);
			});
		}

		function getPricingModelLookupAttributes() {
			var lookupConfigIds = getPricingModelLookupConfigIds();
			var pricingModelLookupAttrs = _.filter(CS.Service.config, function(it) {
				var def = getAttributeDefinition(it);
				return it.attr && _.contains(lookupConfigIds, def.cscfga__Lookup_Config__c);
			});
			return pricingModelLookupAttrs;
		}

		function getPricingModelLookupConfigIds() {
			return _.map(_.filter(CS.Service.getProductIndex().all, function(it) {
					return it && it.attributes && it.attributes.type === 'cscfga__Lookup_Config__c'
						&& (it.cscfga__Object__c === 'cspmb__price_item__c'
						|| it.cscfga__Object__c === 'cspmb__add_on_price_item__c'
						|| it.cscfga__Object__c === 'cspmb__price_item_add_on_price_item_association__c');
				}), function(it) {
					return it.Id;
				}
			);
		}

		function getPrimaryPricingModelLookupAttribute(pricingModelLookups) {
			if (pricingModelLookups.length == 1) {
				return pricingModelLookups[0];
			}
			return _.find(pricingModelLookups, function(it) {
				!!it.attributeFields.__Primary__;
			});
		}

		function getSelectedAddOnIds(addOnAttr) {
			return _.filter(_.map(
				addOnAttr.relatedProducts,
				function(it) {
					return CS.getAttributeValue(makeRef(it.reference, 'CS_AddOn_0')); // This doesn't need to be hardcoded
				}),
				function(it) {
					return it != null;
				}
			);
		}

		function hideControlButtons(attrs) {
			_.each(attrs, function(attr) {
				jQuery('[data-cs-control="' + attr.reference + '"][data-cs-action="addRelatedProduct"]')
				.css({ display: 'none' });
			});
		}

		/*** Configurator util functions ***/

		function prepareDynamicFilterMap(lookupQueryObj, attrRef) {
			var configPrefix = '';
			attrRef = attrRef || '';
			var n = attrRef.lastIndexOf(":");
			if (n != -1) {
				configPrefix = attrRef.substr(0, n);
			}
			var referencedAttributes = lookupQueryObj ? JSON.parse(lookupQueryObj.cscfga__Referenced_Attributes__c) : [];
			var dynamicFilterMap = {};
			var bConfigAttribute = false;
			var attrRef;

			_.each(CS.Service.config, function(it) {
				if (it.attr) {
					bConfigAttribute = false;
					attrRef = it.reference;
					if (configPrefix !== '' && attrRef.lastIndexOf(configPrefix) != -1) {
						if (attrRef.substring(n).split(":").length < 3) {
							bConfigAttribute = true;
						}
					}
					if (configPrefix === '' && attrRef.lastIndexOf(':') == -1) {
						bConfigAttribute = true;
					}
					if (bConfigAttribute) {
						var name = it.attr.Name;
						if (lookupQueryObj === undefined) {
							dynamicFilterMap[name] = it.attr.cscfga__Value__c;
						} else {
							if (_.indexOf(referencedAttributes, name) !== -1) {
								dynamicFilterMap[name] = it.attr.cscfa__Value__c;
							}
						}
					}
				}
			});

		}

		/*
		 * Resolve an expression of the form {lookupAttribute.field} to the lookup field value
		 */
		function resolveLookupValue(exp, ctx) {
			var lk = exp ? exp.match(/\{([^\.]+)\.([^\}]+)\}/) : [];
			if (lk && lk.length && lk.length == 3) {
				var lkName = lk[1];
				var lkField = lk[2];
				var ref = attNameToRef(lkName, CS.Util.getParentReference(ctx));
				if (!ref) {
					console.error('Pricing lookup reference ' + exp + ' could not be resolved.');
					return;
				}
				return CS.getLookupValue(ref, lkField);
			}
		}

		/*
		 * Resolve an attribute name to its reference. Scoped to the context
		 * of the current product (it may be anywhere in the hierarchy, must not
		 * select an Attribute with the same name under a different product position)
		 */
		function attNameToRef(name, context) {
			var atts = _.filter(CS.Service.config, function(it) { return it.attr && it.attr.Name == name && CS.Util.getParentReference(it.reference) == context; });
			if (atts.length == 1) {
				return atts[0].reference;
			}
		}

		function attributeIsPresent(ref) {
			return (CS.Service.config[ref] && CS.Service.config[ref].attr);
		}

		function getAttributeDefinition(node) {
			var index = CS.Service.getProductIndex();
			return index.all[node.definitionId];
		}

		function beforeUpdateHandler(ref, properties) {
			var currentValue = CS.getAttributeValue(ref);
			if (properties.value && properties.value != currentValue) {
				properties._oldVal = currentValue;
			}
		}

		function afterUpdateHandler(ref, properties) {
			var currentValue = CS.getAttributeValue(ref);
			if (properties._oldVal !== undefined) {
				attributeHasChanged(ref, properties._oldVal, properties);
			}
		}

		function attributeHasChanged(ref, oldVal, properties) {
			if (onChangeHandlers[ref] && typeof onChangeHandlers[ref].handler === 'function') {
				onChangeHandlers[ref].handler(ref, oldVal, properties);
			}
		}

		function registerOnChangeHandler(ref, handler) {
			if (!lookupDeletePollerInterval) {
				lookupDeletePollerInterval = window.setInterval(checkForDeletedLookupValues, 500);
			}
			var wrapper = CS.getAttributeWrapper(ref);
			if (wrapper) {
				onChangeHandlers[ref] = {
					type: (wrapper.definition ? wrapper.definition.cscfga__Type__c : wrapper.displayInfo),
					handler: handler,
					lastValue: wrapper.attr.cscfga__Value__c  // for checking for Lookup delete which is not generating an event correctly
				};
			} else {
				console.warn('Attribute ref ' + ref + ' not found, cannot register onChange handler');
			}
		}

		function checkForDeletedLookupValues() {
			_.each(onChangeHandlers, function(handler, ref) {
				if (handler && handler.type === 'Lookup') {
					if (handler.lastValue) {
						if (!CS.getAttributeValue(ref)) {
							console.info('Lookup attribute cleared: ', ref);
							attributeHasChanged(ref, handler.lastValue, { value: '' });
							handler.lastValue = '';
						}
					}
				}
			});
		}

		/**
		 * Every time a price item id is changed the existing addons/related products
		 * are removed and a new set of default addons are added for the new price item id.
		 */
		function priceItemOnChangeHandler(ref, oldVal, properties) {
			if (oldVal && properties.value && oldVal != properties.value) {
				var configRef = CS.Util.getParentReference(ref);
				findAddOnRelatedProductAttributes(configRef)
				.then(function(addOnAttrs) {
					_.each(addOnAttrs, function(attr) {
						// TODO: Why is the data different in addOnAttrs than that which is fetched here?
						var attrib = CS.getAttributeWrapper(attr.reference);
						_.each(attrib.relatedProducts, function(rp) {
							CS.Service.removeRelatedProduct(rp.reference);
						});
					});
				})
				.then(function() {
					CS.Rules.evaluateAllRules();
					return waitForRulesToComplete();
				})
				.then(function() {
					markProductFirstRunNotCompleted(configRef);
					addDefaultAddOns(configRef);
				});
			}
		}

		function setLookupAttributeValue(attrRef, recordId) {
			var wrapper = CS.getAttributeWrapper(attrRef);
			var index = CS.Service.getProductIndex();
			var def = index.all[wrapper.definitionId];
			var lc = index.all[def.cscfga__Lookup_Config__c];

			var lookupAttribute = {
				'attributeId': wrapper.attr.Id,
				'attributeValue': recordId,
				'attributeDefinitionId': def.Id,
				'attributeLookupConfigId': lc.Id,
				'attributeObjectMappingId': lc.cscfga__Search_Columns__c
			};
			return loadLookupRecord(JSON.stringify(lookupAttribute))
			.then(function(result) {
				var attKey = lookupAttribute.attributeValue;
				var rec = result[attKey] || {};
				var lookupData = _.extend({}, rec);
				lookupData.columnMap = rec.columnMap;
				CS.lookupRecords[attKey] = lookupData;
				CS.setAttributeValue(attrRef, recordId);
			});
		}

		function buildAssociationGroups(assocs) {
			var groups = {};
			_.each(assocs, function(assoc) {
				var name = assoc.cspmb__group__c;
				var gm = groups[name];
				if (!gm) {
					groups[name] = gm = {};
				}
				gm[assoc.cspmb__add_on_price_item__c] = parseInt(assoc.cspmb__max__c, 16) || 0;
			});
			return groups;
		}

		function getAssociationGroupCounts(assocs, groups, selectedAddOnIds) {
			var groupCounts = {};
			var assocsById = _.object(_.map(assocs, function(assoc) {
				return [assoc.cspmb__add_on_price_item__c, assoc];
			}));

			_.each(selectedAddOnIds, function(id) {
				var assoc = assocsById[id];
				if (assoc) {
					var count = groupCounts[assoc.cspmb__group__c] || (groupCounts[assoc.cspmb__group__c] = 0);
					groupCounts[assoc.cspmb__group__c] = count + 1;
				}
			});

			return groupCounts;
		}

		/*
		 * In regular Configurator, avoid infinite recursion by setting an Attribute value
		 * to indicate that default add-ons have been evaluated/added
		 */
		function markProductFirstRunCompleted(configRef) {
			console.log('EAPI compatibility: first run completed for ref ' + configRef);
			CS.setAttributeValue(CS.Util.generateReference('First_Run', { ref: configRef }), 'true');
		}

		function markProductFirstRunNotCompleted(configRef) {
			CS.setAttributeValue(CS.Util.generateReference('First_Run', { ref: configRef }), '');
		}

		function productIsNewlyAddedToBasket(ref) {
			var firstRunFlagRef = CS.Util.generateReference('First_Run', { ref: ref });
			if (attributeIsPresent(firstRunFlagRef)) {
				if (!CS.getAttributeValue(firstRunFlagRef)) {
					CS.setAttributeValue(firstRunFlagRef, 'true');
					return true;
				}
			} else {
				console.warn('EAPI compatibility: Cannot evaluate default add-ons as no first run attribute present');
			}
			return false;
		}

		function blankForNull(val) {
			return val ? val : '';
		}

		function asDecimal(val, scale) {
			var f = parseFloat(val);
			if (isNaN(f)) {
				return '';
			} else {
				return f.toFixed(scale);
			}
		}

		function error(err) {
			console.error(err);
			return Promise.reject(err);
		}

		function keysToLowerCase(obj) {
			var data = _.isArray(obj) ? [] : {};
			_.each(obj, function(val, key) {
				if (key.toLowerCase) {
					key = key.toLowerCase();
				}
				if (val && typeof val === 'object') {
					data[key] = keysToLowerCase(val);
				} else {
					data[key] = val;
				}
			});
			return data;
		}

		function makeRef(ref, tail) {
			return (ref ? ref + ':' : '') + tail;
		}

		function createRelatedProducts(attr, addOns) {
			var availableProducts = CS.Service.getAvailableProducts(attr.reference);
			var defId = availableProducts[0].cscfga__Product_Definition__c;
			var currentRef = CS.Service.getCurrentConfigRef();
			var bindingCache = CS.binding;
			var promise = _.reduce(addOns, function(promise, addOn) {
				return promise.then(function() {
					return createAddOnRelatedProductInline(attr, defId, addOn);
				});
			}, emptyPromise);

			if (!availableProducts || !availableProducts.length) {
				console.error('EAPI Compatibility: no related product definitions avaialable; there should be exactly one for attribute ' + attr.reference);
				return Promise.reject('No related product available.');
			}

			return promise.then(function() {
				console.info('EAPI compatibility: evaluating rules after adding related product');
				CS.Rules.evaluateAllRules();
				return waitForRulesToComplete()
				.then(function() {
					return lookupPromise;
				}).then(function() {
					CS.Rules.evaluateAllRules(); // reprocess after retrieving lookup records
					return waitForRulesToComplete();
				});
			});
		}

		function createAddOnRelatedProductInline(attr, defId, addOn) {
			var parent = CS.getConfigurationWrapper(CS.Util.getParentReference(attr.reference));
			return loadProduct(defId)
			.then(function() {
				return createConfiguration(attr.reference, defId, parent);
			})
			.then(function(config) {
				console.info('Created Configuration: ', config);
				var anchorRef = CS.Util.getAnchorReference(attr.reference);
				var wrapper = CS.getConfigurationWrapper(anchorRef);
				CS.binding.update(anchorRef, { 'relatedProducts': wrapper.relatedProducts });

				return new Promise(function(resolve, reject) {
					var ref = CS.Service.getCurrentScreenRef();
					var html = CS.DataBinder.buildScreen(ref, config, CS.screens);
					var screen = jQuery(html);
					var containerSelector = 'section[data-cs-displays="Viewport"]';
					CS.DataBinder.bind(CS.Service.config, CS.Service.getProductIndex(), jQuery(containerSelector).add(screen));
					
					// rebind missing actions for lookup, why are they missing in the first place?
					setUpdateEventBinding();
					
					// TODO remove hardcoded attr reference below
					var context = { ref: config.reference };
					var addonAssociationReference = CS.Util.generateReference('CS_AddOnAssociation', context);
					console.info('EAPI compatibility: setLookupAttributeValue ', addonAssociationReference, addOn.id);
					return setLookupAttributeValue(addonAssociationReference, addOn.id)
					.then(function() {
						var validation = CS.Service.validateCurrentConfig();
						if (validation.isValid) {
							CS.setConfigurationProperty(config.reference, 'status', 'Valid');
						}
						
						var newlyCreatedConfigurationWrapper = CS.getConfigurationWrapper(config.reference);
						delete newlyCreatedConfigurationWrapper.unsaved;
						delete newlyCreatedConfigurationWrapper.snapshot;
						resolve();
					});
				})
				.catch(function(error) {
					console.error(error);
				});
			});
		}

		function getOffScreenElement() {
			var el = jQuery('#offScreenElement');
			if (!el.size()) {
				jQuery('body').append('<div style="display: none"><div id="offScreenElement"></div></div>');
				el = jQuery('#offScreenElement');
			}
			return el;
		}

		function loadProduct(id) {
			var index = CS.Service.getProductIndex(id);
			if (!index) {
				return CS.Service.loadProduct(id, function(index) {
					jQuery.extend(CS.screens, CS.DataBinder.prepareScreenTemplates(index));
					return index;
				});
			} else {
				return emptyPromise;
			}
		}

		function getContext(ref, attrName, idx, parent) {
			return { ref: ref, attrName: attrName, index: (idx || 0), parent: parent };
		}
		
		function setUpdateEventBinding() {
		    function validateValueForPattern(value, attrDef) {
		        var prefix = CS.Util.configuratorPrefix;
		        var validationPattern = attrDef[prefix + 'Pattern__c'];
		        // Normalization of value is done on update, but we need it here to validate it correctly
		        var typeInfo = { 'type': attrDef[prefix + 'Data_Type__c'], 'scale': attrDef[prefix + 'Scale__c'] };
		        var normValue = CS.DataConverter.normalizeValue(CS.DataConverter.unlocalizeValue(value, typeInfo), typeInfo);
		        if (normValue && validationPattern) {
		            // Force complete match, as is required in V1
		            var re = new RegExp('^' + validationPattern + '$');
		            if (!re.test(normValue)) {
		                return attrDef[prefix + 'Custom_Validation_Error_Message__c'];
		            }
		        }
		        return;
		    }
		
		    CS.binding.on('beforeUpdate', function(ref, properties, event) {
		        CS.Log.debug('Before Update', ref, properties, event);
		        var attrDef = CS.Service.getAttributeDefinitionForReference(ref);
		        var value = properties['value'];
		        return validateValueForPattern(value, attrDef);
		    });
		
		    CS.binding.on('afterUpdate', function(ref, properties, event) {
		        CS.Log.debug('After Update', ref, properties, event);
		
		        if (!CS.rulesTimer) {
		            CS.rulesTimer = window.setTimeout(function() {
		                CS.Rules.evaluateAllRules('after update: ' + ref);
		                CS.rulesTimer = undefined;
		            }, 400);
		        }
		    });
		}

		function buildConfig(def, reference, context) {
			var prefix = CS.Util.configuratorPrefix;
			var wrapper = {
				"reference": reference,
				"config": {
					"attributes": {
						"type": "Product_Configuration__c"
					}
				}
			};
			wrapper.config[prefix + 'Attribute_Name__c'] = context.attrName;
			wrapper.config[prefix + 'Billing_Frequency__c'] = CS.getFrequencyValueForName(def[prefix + 'Default_Billing_Frequency__c']);
			wrapper.config[prefix + 'Contract_Term__c'] = def[prefix + 'Default_Contract_Term__c'];
			wrapper.config[prefix + 'Contract_Term_Period__c'] = CS.getPeriodValueForName(def[prefix + 'Default_Contract_Term_Period__c']);
			wrapper.config[prefix + 'Description__c'] = def[prefix + 'Description__c'];
			wrapper.config[prefix + 'Index__c'] = context.index;
			wrapper.config[prefix + 'Last_Screen_Index__c'] = 0;
			wrapper.config.Name = CS.Util.getFirstDefinedValue([def.Name, def[prefix + 'Description__c']]);
			wrapper.config[prefix + 'Product_Definition__c'] = def.Id;
			wrapper.config[prefix + 'Recurrence_Frequency__c'] = CS.getFrequencyValueForName(def[prefix + 'Default_Frequency__c']);
			wrapper.config[prefix + 'Configuration_Status__c'] = 'Incomplete';
			wrapper.config[prefix + 'Validation_Message__c'] = '';
			wrapper.config[prefix + 'Product_Family__c'] = (def.Name.length > 40) ? def.Name.substr(0, 40) : def.Name;

			return wrapper;
		}

		function buildAttribute(def, context, selectOptions, attributeFields) {
			context = context || {};
			var prefix = CS.Util.configuratorPrefix;
			var wrapper = {
				"attr": {
					"attributes": {
						"type": prefix + "Attribute__c"
					}
				},
				"attributeFields": {},
				"definitionId": def.Id,
				"displayInfo": context.displayInfo || def[prefix + 'Type__c'],
				"reference": CS.Util.generateReference(def.Name, context),
				"relatedProducts": [],
				"selectOptions": selectOptions
			};
			var typeInfo = { 'type': def[prefix + 'Data_Type__c'], 'scale': def[prefix + 'Scale__c'] };

			wrapper.attr[prefix + "Attribute_Definition__c"] = def.Id;
			wrapper.attr[prefix + 'Cascade_value__c'] = def[prefix + 'Cascade_value__c'];
			wrapper.attr[prefix + 'Display_Value__c'] = (
				def[prefix + 'Type__c'] === 'Calculation'
					? null
					: CS.DataConverter.localizeValue(def[prefix + 'Default_Value__c'], typeInfo)
			);
			wrapper.attr[prefix + 'Hidden__c'] = def[prefix + 'Hidden__c'];
			wrapper.attr[prefix + 'is_active__c'] = true;
			wrapper.attr[prefix + 'Is_Line_Item__c'] = def[prefix + 'Is_Line_Item__c'];
			wrapper.attr[prefix + 'Is_Required__c'] = def[prefix + 'Required__c'];
			wrapper.attr[prefix + 'Line_Item_Sequence__c'] = def[prefix + 'Line_Item_Sequence__c'];
			wrapper.attr[prefix + 'Line_Item_Description__c'] = def[prefix + 'Line_Item_Description__c'];
			wrapper.attr.Name = def.Name;
			wrapper.attr[prefix + 'Price__c'] = def[prefix + 'Base_Price__c'] || 0;
			wrapper.attr[prefix + 'Value__c'] = (
				def[prefix + 'Type__c'] === 'Calculation'
					? ''
					: CS.DataConverter.normalizeValue(def[prefix + 'Default_Value__c'], typeInfo)
			);
			wrapper.attr[prefix + 'Recurring__c'] = def[prefix + 'Recurring__c'];

			if (def[prefix + 'Type__c'] === 'Select List' && def[prefix + 'Default_Value__c'] && selectOptions) {
				for (var i = 0; i < selectOptions.length; i++) {
					if (selectOptions[i] == def[prefix + 'Default_Value__c']) {
						wrapper.attr[prefix + 'Display_Value__c'] = selectOptions[i].Name;
						break;
					}
				}
			}

			_.each(attributeFields, function(a) {
				setAttributeField(wrapper, a.Name, a[prefix + 'Default_Value__c']);
			});

			return wrapper;
		}

		function createConfiguration(anchorRef, newProductId, parent, promiseContainer) {
			var configData = CS.Service.config;
			var productIndex = CS.Service.getProductIndex(newProductId);

			CS.Log.info('EAPI Compatibility createConfiguration(): ', anchorRef, '/', newProductId, '/', parent);

			if (!productIndex) {
				throw 'Product index for ' + newProductId + ' not found';
			}

			var productDef = productIndex.productsById[newProductId],
				wrapper = configData[anchorRef],
				newAttrDefs = productIndex.attributeDefsByProduct[newProductId],
				idx = 0,
				name,
				newConfig = {},
				context,
				attr,
				defId,
				ref;

			if (anchorRef !== ROOT_REFERENCE && !wrapper) {
				return error('Could not locate reference ', anchorRef, configData);
			}

			if (!productDef) {
				return error('Could not find product definition for id', newProductId);
			}

			if (!newAttrDefs) {
				return error('Could not find attribute definitions for product id', newProductId);
			}

			if (anchorRef === ROOT_REFERENCE) {
				// root config
				ref = anchorRef;
			} else {
				// attaching a related product configuration to an attribute on the parent
				idx = wrapper.relatedProducts.length;
				name = wrapper.attr.Name;
				ref = CS.Util.stripReference(anchorRef) + idx;
			}
			context = getContext(ref, name, idx, parent);

			var newConfigWrapper = buildConfig(productDef, ref, context);

			CS.Log.info('Creating configuration for reference ' + ref);

			if (anchorRef !== ROOT_REFERENCE) {
				// Link related product to parent and mark as unsaved
				newConfigWrapper.parent = parent;
				newConfigWrapper.unsaved = true;
				var relatedProducts = wrapper.relatedProducts.slice(0);
				relatedProducts[idx] = newConfigWrapper;
				CS.binding.update(anchorRef, { relatedProducts: relatedProducts });
			}

			var attrContext = { ref: context.ref, index: 0 };

			for (defId in newAttrDefs) {
				attr = buildAttribute(newAttrDefs[defId], attrContext, productIndex.find('selectOptionsByAttribute', defId), productIndex.find('attributeFieldDefsByAttributeDef', defId));
				configData[attr.reference] = attr;
			}
			var customLookupConfigs = getCustomLookupConfigs(newAttrDefs, productIndex);

			populateScreens(newProductId, newConfigWrapper);

			if (configData[ref]) {
				// Overlay config on parent attribute node in configuration for related product #0
				_.extend(configData[anchorRef], newConfigWrapper);
			} else {
				configData[ref] = newConfigWrapper;
			}

			var linkedObjectPropertiesCacheKey = CS.Service.getLinkedObjectId() + '|' + newProductId;

			var linkedObjectPropertiesExist = CS.Util.isObject(configData[ref]['linkedObjectProperties']);
			var linkedObjectApiExists = (
				CS.Service.loadLinkedObjectProperties instanceof Function
				&& CS.Service.getLinkedObjectId instanceof Function
			);

			if (linkedObjectPropertiesExist) {
				// If cache key doesn't exist... (mind the negation operator)
				if (!linkedObjectPropertiesCache.hasOwnProperty(linkedObjectPropertiesCacheKey)) {
					linkedObjectPropertiesCache[linkedObjectPropertiesCacheKey] =
						configData[ref]['linkedObjectProperties'];
				}
			}

			loadRulesForConfig(ref, productDef);

			if (linkedObjectPropertiesExist || !linkedObjectApiExists) {
				console.warn('EAPI compatibility: linked properties exist – loading rules for config');
				loadRulesForConfig(ref, productDef);
			} else {
				function _loadLinkedObjectProperties(deferred, params) {
					var key = params.linkedObjectPropertiesCacheKey;
					if (CS.Util.isObject(params.linkedObjectPropertiesCache[key])) {
						CS.Log.info('***** Linked object properties cache hit, cache key: ', key);
						params.configData[params.ref]['linkedObjectProperties'] = params.linkedObjectPropertiesCache[key];
						deferred.resolve(params);
					} else {
						CS.Log.info('***** Loading linked object properties (deferred)...');
						params.api.loadLinkedObjectProperties(
							params.api.getLinkedObjectId(),
							params.newProductId,
							function linkedObjectPropertiesCallback(linkedObjectProperties) {
								if (!CS.Util.isObject(linkedObjectProperties)) {
									linkedObjectProperties = {};
								}
								params.linkedObjectPropertiesCache[params.linkedObjectPropertiesCacheKey] =
									params.configData[params.ref]['linkedObjectProperties'] =
										linkedObjectProperties;
								deferred.resolve(params);
							}
						);
					}
				}

				function _loadCustomLookupReferencedAttributes(deferred, params) {
					if (!params.configData[params.ref]['customLookupReferencedAttributes'] && Object.keys(params.customLookupConfigs).length > 0) {
						CS.Log.info('***** Loading Custom Lookup Referenced Attributes (deferred) ...');

						params.api.loadCustomLookupReferencedAttributes(
							JSON.stringify(params.customLookupConfigs),
							function(customLookupReferencedAttributes) {
								if (CS.Util.isObject(customLookupReferencedAttributes)) {
									params.configData[params.ref]['customLookupReferencedAttributes'] = customLookupReferencedAttributes;
								}
								deferred.resolve(params);
							}
						);
					} else {
						CS.Log.info('***** NOT Loading Custom Lookup Referenced Attributes (already loaded) ...');
						deferred.resolve(params);
					}
				}

				function _loadRulesForConfig() {
					CS.Log.info('***** Loading rules for configuration (deferred)...', ref, productDef);
					loadRulesForConfig(ref, productDef);
				}

				console.warn('EAPI compatibility: linked properties do not exist – starting promise chain');

				var self = this;
				if (!promiseContainer || !promiseContainer.promise) {
					promiseContainer = {};

					var executionChain = CS.Util.getDeferred();
					promiseContainer.promise = CS.Util.getPromise(executionChain);
					executionChain.resolve();
				}
				promiseContainer.promise = promiseContainer.promise.then(CS.Util.defer(function(d) {
					d.resolve({
						api: api,
						configData: configData,
						customLookupConfigs: customLookupConfigs,
						linkedObjectPropertiesCache: linkedObjectPropertiesCache,
						linkedObjectPropertiesCacheKey: linkedObjectPropertiesCacheKey,
						newProductId: newProductId,
						ref: ref
					});
				})).then(
					CS.Util.defer(_loadLinkedObjectProperties, self)
				).then(
					CS.Util.defer(_loadCustomLookupReferencedAttributes, self)
				).then(
					_loadRulesForConfig
				);
			}

			CS.Log.info('###>>> Ending createConfiguration(): ', newConfigWrapper);
			return newConfigWrapper;
		}

		function loadRulesForConfig(reference, productDef) {
			CS.Log.info('EAPI compatibilty: loadRulesForConfig', reference, productDef);
			if (CS.Rules.hasRules(reference)) {
				return;
			}

			var referenceField = CS.Util.configuratorPrefix + 'reference__c';
			if (!productDef.hasOwnProperty(referenceField)) {
				CS.Log.error('Could not find the field reference__c in the current product definition', productDef);
				return;
			}

			var definitionRef = productDef[referenceField];
			if (!definitionRef) {
				CS.Log.error('Current product definition\'s reference is not defined: ', productDef);
				return;
			}

			var tpl = jQuery('#' + CS.Util.generateId(definitionRef) + '__rules');
			var idx = 0; // this will be for 'leaf' Attributes which presently will always be index 0 (this will change if attribute arrays are introduced using the leaf node index)

			if (tpl.size() === 0) {
				CS.Log.warn('Could not find rules template with reference: ' + definitionRef);
			} else {
				var rules = CS.Util.applyContext(tpl.get(0).innerHTML, idx, reference);
				CS.Rules.addRules(reference, rules);
			}
		}

		function populateScreens(productId, config) {
			var productIndex = CS.Service.getProductIndex(productId),
				screensByParent = null,
				configScreens = [],
				attrRefsByDef = {},
				newAttrDefs = productIndex.attributeDefsByProduct[productId],
				attrContext = { ref: '', index: 0 };
			var prefix = CS.Util.configuratorPrefix;

			var screenFlowName = CS.Service.getScreenFlowName();
			var usesScreenflow = false;
			if (screenFlowName !== '') {
				var flowIdsByProduct = productIndex.screenFlowIdsByNameAndProduct[screenFlowName];
				if (flowIdsByProduct && flowIdsByProduct[productId]) {
					var screenFlowId = flowIdsByProduct[productId];
					screensByParent = productIndex.screensByScreenFlow[screenFlowId];
					usesScreenflow = true;
				}
			}
			if (!usesScreenflow) {
				screensByParent = productIndex.screensByProduct[productId];
			}

			for (var defId in newAttrDefs) {
				var ref = CS.Util.generateReference(newAttrDefs[defId].Name, attrContext);
				attrRefsByDef[defId] = ref;
			}

			for (var idx in screensByParent) {
				var screen = screensByParent[idx];
				var attrs = productIndex.attributeDefsByScreen[screen.Id];
				var attrRefs = [];

				for (var attrId in attrs) {
					attrRefs.push(attrRefsByDef[attrId]);
				}

				// additional check if attribute is on a screenflow to add its reference
				var screenSections = productIndex.screenSectionsByScreen[screen.Id];
				var screenSectionIds = [];

				_.each(productIndex.screenSectionsByScreen[screen.Id], function(screenSection) {
					screenSectionIds.push(screenSection.Id);
				});
				_.each(Object.keys(productIndex.sectionsMapByAttributeDef), function(attributeDefId) {
					var attributeScreenSections = Object.keys(productIndex.sectionsMapByAttributeDef[attributeDefId]);
					if (_.intersection(screenSectionIds, attributeScreenSections).size() > 0) {
						attrRefs.push(attrRefsByDef[attributeDefId]);
					}
				});

				configScreens[idx] = {
					id: screen.Id,
					reference: screen._reference,
					attrs: attrRefs
				};
				if ((!config.config[prefix + "Screen_Flow__c"]) && (screen[prefix + "Screen_Flow__c"])) {
					config.config[prefix + "Screen_Flow__c"] = screen[prefix + "Screen_Flow__c"];
				}
			}

			config.screens = configScreens;
		}

		function getCustomLookupConfigs(attributeDefinitions, productIndex) {
			var customLookupConfigs = {};
			var prefix = CS.configuratorPrefix;

			for (var defId in attributeDefinitions) {
				if (!attributeDefinitions.hasOwnProperty(defId)) { continue; }

				var lookupConfigId = attributeDefinitions[defId][prefix + "Lookup_Config__c"];
				if (lookupConfigId) {
					var lookupConfig = productIndex.all[lookupConfigId];
					var lookupCustomisationClass = lookupConfig[prefix + "lookup_customisations_impl__c"];
					if (lookupCustomisationClass && !customLookupConfigs[lookupConfigId]) {
						customLookupConfigs[lookupConfigId] = lookupConfig[prefix + "lookup_customisations_impl__c"];
					}
				}
			}

			return customLookupConfigs;
		}

		function setAttributeField(wrapper, fieldName, value) {
			var attributeFields = wrapper.attributeFields;
			var field;
			var prefix = CS.Util.configuratorPrefix;

			if (!attributeFields) {
				wrapper.attributeFields = attributeFields = {};
			}

			field = attributeFields[fieldName];

			if (!field) {
				attributeFields[fieldName] = field = {
					attributes: {
						"type": prefix + "Attribute_Field__c"
					},
					Name: fieldName
				};
			}

			field[prefix + 'Value__c'] = value;

			return field;
		}

		function waitForRulesToComplete(state) {
			function continueWaiting(state) {
				return new Promise(function(resolve, reject) {
					window.setTimeout(function(state) {
						return waitForRulesToComplete(state).then(resolve);
					}, 250, state);
				});
			}

			if (!state) {
				state = { c: 1, sc: 1 };
			}

			if (state.c > 40 || (CS.rulesTimer === undefined && !CS.lookupQueriesAreQueued())) {
				if (state.sc < 2) {
					state.sc += 1;
					state.c = 1;
					console.log('waitForRulesToComplete: waiting for secondary evaluation...');
					return continueWaiting(state);
				}
				console.log('waitForRulesToComplete: rules complete.');
				return Promise.resolve();
			} else {
				state.c += 1;
				state.sc = 1;
				console.log('waitForRulesToComplete: waiting... ' + state.c);
				return continueWaiting(state);
			}
		}

		function generate18CharId(id) {
			if (id === null) {
				return null;
			}
			if (id.length != 15) {
				return id;
			}
			var suffix = '';
			var flags;
			for (var i = 0; i < 3; i++) {
				flags = 0;
				for (var j = 0; j < 5; j++) {
					var c = id.substring(i * 5 + j, i * 5 + j + 1);
					//Only add to flags if c is an uppercase letter:
					if (c.toUpperCase() == c && c >= 'A' && c <= 'Z') {
						flags = flags + (1 << j);
					}
				}
				if (flags <= 25) {
					suffix = suffix + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.substring(flags, flags + 1);
				} else {
					suffix = suffix + '012345'.substring(flags - 26, flags - 25);
				}
			}
			return id + suffix;
		}

		return {
			addDefaultAddOns: addDefaultAddOns,
			addDefaultAddOnsForAttribute: addDefaultAddOnsForAttribute,
			insertAddOn: insertAddOn,
			createRelatedProducts: createRelatedProducts,
			displayPricingWidget: displayPricingWidget,
			createConfiguration: createConfiguration,
			createAddOnRelatedProductInline: createAddOnRelatedProductInline,
			findAddOnRelatedProductAttributes: findAddOnRelatedProductAttributes,
			getPriceItemForConfig: getPriceItemForConfig,
			priceItemOnChangeHandler: priceItemOnChangeHandler,
			resolveLookupValue: resolveLookupValue,
			runCompatibilityFunctionsModel2: runCompatibilityFunctionsModel2,
			setLookupAttributeValue: setLookupAttributeValue,
			setConfigurationNames: setConfigurationNames,
			setLineItemDescriptions: setLineItemDescriptions,
			setPrices: setPrices,
			waitForRulesToComplete: waitForRulesToComplete
		};
	} // End buildCompatibilityFunctions

	CS.EAPI = CS.EAPI || {};
	_.extend(CS.EAPI, buildCompatibilityFunctions());

});
