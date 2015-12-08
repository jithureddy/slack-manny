taskHandler = module.exports = {}

jsonfile = require('jsonfile')

JSONPATH = 'DATA.json'

WORK_ITEMS = ['TASK', 'PROJECT']

taskHandler.addItem = (config) ->
    jsonfile.readFile JSONPATH, (error,data) ->
        if error
            return false
        else
            if data and data.length > 0 
                data.push config

            else 
                data = []
                data.push newData

            jsonfile.writeFile JSONPATH, data, {spaces:2}, (err) ->
                if err
                    return false
            console.log "writing is done " 
    console.log "reading is done "       
    return true

        
taskHandler.ID = ->
  # Math.random should be unique because of its seeding algorithm.
  # Convert it to base 36 (numbers + letters), and grab the first 9 characters
  # after the decimal.
  '_' + Math.random().toString(36).substr(2, 9)
taskHandler.createWorkitem = (robot,res) ->
  type = res.match[1] || res.match[4]
  typeDetail = res.match[2] || res.match[5]
  user = res.match[3]
  currentUser = res.message.user

  newWorkItem = 
         type: type
         status: 'NEW'
         description: typeDetail
         assignedto: user
         association : []
          
  if WORK_ITEMS.indexOf(type.toUpperCase()) > -1
        if !user and type.toUpperCase() is WORK_ITEMS[0]
            console.log robot.brain.get('isPartialTaskExists')
            if robot.brain.get('isPartialTaskExists')
                 res.reply "Hey there is already a task with out owner-- Under developement"
                 robot.brain.set 'isPartialTaskExists', false
            else 
            
                partialTaskId = taskHandler.ID()
                #set partial task details to brain
                
                robot.brain.data.partialTasks[partialTaskId] = newWorkItem
                if robot.brain.data.partialTaskIds
                    console.log "I am about to push ID #{partialTaskId}" 
                    robot.brain.data.partialTaskIds.push partialTaskId
                robot.brain.set 'isPartialTaskExists', true
                #{currentUser.name} 
                res.reply "who do you want me to create the task for?"
                return
        else             
           status = taskHandler.addItem(newWorkItem)
           console.log status
           owner = ''
           if user and user.toUpperCase() is 'ME'
                owner = 'you'
           else if user
                owner = user      
           if status
                message = "I have created the #{type}"
                if type.toUpperCase() is WORK_ITEMS[0]
                    message = message + "for #{owner}"
                res.reply message
                return
           else
                res.reply "There is something wrong in reading/saving the data"
                return
                
  else
    res.reply "Creation of #{type} is not available at this time"
    return
taskHandler.clearBrainData = (robot,res) -> 
    robot.brain.data.partialTasks = {}
    robot.brain.data.partialTaskIds = []
    robot.brain.set 'isPartialTaskExists', false
    return
taskHandler.handlePartialTask = (robot,res) -> 
        user1 = res.match[1]
        user2 = res.match[2]
        user = null
        owner = ''
        console.log "#{user1}, #{user2}"
    
        if user1.toUpperCase() is 'ME' and !user2
            user = user1
            owner = 'you'
        else if user2
            user = user2
            owner = user2
        else if user1 and user1.toUpperCase() is 'ME' and user2
            console.log "Needs to resolve this"
            
            #need to resolve this scenario , where user2 value matches current user.
        if user
            if robot.brain.data.partialTaskIds.length > 0 and robot.brain.data.partialTasks
                partialTaskId = robot.brain.data.partialTaskIds.shift() 
                if partialTaskId
                    workitems_to_be_saved = robot.brain.data.partialTasks[partialTaskId]
                    workitems_to_be_saved.assignedto = user
                    status = taskHandler.addItem(workitems_to_be_saved)
                    if status
                        res.reply "I have created the #{workitems_to_be_saved.type} for #{owner}" 
                        taskHandler.clearBrainData(robot,res)
                        return
                    else
                        res.reply "There is something wrong in reading/saving the data"
                        return
            else 
                res.reply "Looks like there are no tasks that needs to be created"
                return 
        else 
            res.reply "No user present with that name"    
            return    
                
                
                