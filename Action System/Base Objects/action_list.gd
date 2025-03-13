class_name ActionList extends Node
##Base ActionList class.

var actions: Array[Action]


#disable processing, ActionLists are processed only by Executors
func _ready():
    set_process_mode(PROCESS_MODE_DISABLED)

##Verify action and add it to list.
func add_action(action_to_add:Action):
    if(action_to_add.verify()):
        actions.push_back(action_to_add)
    else:
        print("action failed verification")
        breakpoint


##Update each action in the list in order.
func update_list(dt:float):
    var removals_necessary = 0
    for action in actions:
        action.update_action(dt)
        if action.isDone:
            if action.looping:
                #reset action to the start of its execution
                action.elapsed_time = 0.0
                action.first_update = true
            elif action.oscillating:
                #reverse direction of action
                if action.currently_reversing:
                    action.currently_reversing = false
                else:
                    action.currently_reversing = true
            else:
                action.should_delete = true
                removals_necessary += 1
        #blocking actions prevent rest of list from executing
        if action.blocking:
            break
    #individually remove actions
    while(removals_necessary >0):
        for action in actions:
            if action.should_delete:
                action._end_action()
                actions.erase(action)
                removals_necessary -=1
                #stop iterating since list changed
                break		
    
func destroy_list():
    var removals_necessary = actions.size()
    while(removals_necessary > 0):
        for action in actions:
            action._end_action()
            action.queue_free()
        
            actions.erase(action)
            removals_necessary -=1
            #stop iterating since list changed
            break		
    queue_free()
    
#create a deep copy of this object
#including deep copies of the contained actions		
func _clone() -> ActionList :
    var newActionList : ActionList = new()
    for action in actions:
        newActionList.add_action(action._clone())
    return newActionList
