(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?l - location ?al - location)
      :precondition (and (no-robot ?al) (connected ?l ?al) (at ?r ?l) (free ?r))
      :effect (and (at ?r ?al) (no-robot ?l) (not (at ?r ?l)) (not (no-robot ?al)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?p - pallette ?r - robot ?l - location ?al - location)
      :precondition (and (connected ?l ?al) (at ?r ?l) (at ?p ?l) (no-robot ?al) (no-pallette ?al))
      :effect (and (at ?r ?al) (at ?p ?al) (no-robot ?l) (no-pallette ?l) (not (no-robot ?al)) (not (no-pallette ?al)) (not (at ?r ?l)) (not (at ?p ?l)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?s - shipment ?o - order ?l - location ?si - saleitem ?p - pallette)
      :precondition (and (packing-location ?l) (packing-at ?s ?l) (not (includes ?s ?si)) (contains ?p ?si) (at ?p ?l))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (packing-location ?l) (ships ?s ?o) (not (complete ?s)) (not (available ?l)) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l) (not (packing-at ?s ?l)) (not (started ?s)))
   )

)
