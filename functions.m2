trim' = Q -> 
    image(generators Q)/
        intersect(image generators Q, image relations Q)
        
actions = M -> 
    for i from 0 to numColumns(gens(M))-1 
        list basis((ring M)/(ann((ring M)*(M_i))))