/**
 * Used as a Observer implementation class for firing the
 * util methods when Orders/Subscriptions/Services are being
 * generated.
 * Currently used for decomposing the orders.
 *
 * @author Tomislav Blazek
 * @ticket SFOM-25
 * @since  09/11/2016
 */
global with sharing class LG_ObserverImpl implements csordcb.ObserverApi.IObserver {

	global LG_ObserverImpl(){

	}

	global void execute(csordcb.ObserverApi.Observable o, Object arg) {

		csordtelcoa.OrderGenerationObservable observable = (csordtelcoa.OrderGenerationObservable)o;

		LG_DecomposeOrderUtil decomposeUtil = new LG_DecomposeOrderUtil(observable.getOrderIds());
		decomposeUtil.startOrderDecomposition();

		LG_DecomposeOrderUtil.relateNumberAssets(observable.getServiceIds());
	}
}