## CoffeeScript
## Description:
##   Example scripts for you to examine and try out.
##
## Notes:
##   They are commented out by default, because most of them are pretty silly and
##   wouldn't be useful and amusing enough for day to day huboting.
##   Uncomment the ones you want to try and experiment with.
##
##   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
#
#module.exports = (robot) ->
# 
# jsonfile = require('jsonfile')
#    
# fs = require('fs')
# util = require('util')
# #workitemsutil = require('./createWorkitemUtil.js')
# JSONPATH = 'DATA.json'
#
# robot.respond /Create a (.*) with name  (.*) , description as (.*) and assign it to (.*)/i, (res) ->
#        itemType = res.match[1]
#        itemName = res.match[2]
#        assignedTo = res.match[4]
#        description = res.match[3]
#
#        newData = 
#            name: itemName,
#            type: itemType
#            description: description
#            association : [assignedTo]
#
#
#        jsonData = jsonfile.readFileSync JSONPATH
#
#        if jsonData.length > 0 
#            jsonData.push newData
#        else 
#            jsonData = [] 
#            jsonData.push newData
#
#        jsonfile.writeFile JSONPATH, jsonData , {spaces: 2} , (err) ->
#            res.reply "Hey , problem in saving the data.."
#            return 
#
#        res.reply "#{itemType} is created with name #{itemName}" 
# robot.respond /Manny list all (.*)s assigned to (.*)/i, (res) ->
#        itemType = res.match[1]
#        assignedUser = res.match[2]
#        
#        items = ['iteration','story','task']  
#        if itemType in items
#          jsonfile.readFile JSONPATH, (error,data) ->
#            workitemsList = ''
#            for workitem in data
#                if workitem.assignedto == assignedUser
#                   workitemsList += 'Name - '+workitem.name+ ' Description -' + workitem.description+'\n'
#
#
#            if workitemsList ==  ''
#                res.reply "Looks like no user with this name #{assignedUser} as such..!"
#            else 
#                res.reply "Here are the list of workitems assigned to #{assignedUser} \n #{workitemsList}"
#        else 
#            res.reply "please ask for one of these"+ (item for item in items)
# robot.respond /Manny create a (.*) with name (.*)/i, (res) ->
#        itemType = res.match[1]
#        itemName = res.match[2]
#        assignedTo = ''
#        description = ''
#        status = ''
#    
#        newData = 
#            name: itemName
#            type: itemType
#            status: status
#            description: description
#            assignedto: assignedTo
#            association : [assignedTo]
#    
#       
#        jsonfile.readFile JSONPATH, (error,data) ->
#            if error
#                console.log error
#                res.reply "Some thing wrong with data , let me come back"
#            
#            if data and data.length > 0 
#                console.log data
#                data.push newData
#                
#            else 
#                data = []
#                data.push newData
#                 
#            jsonfile.writeFile JSONPATH, data, {spaces:2}, (err) ->
#                if err
#                    res.reply err 
#                    return 
#       
#        res.reply "#{itemType} is created with name #{itemName}"        
# robot.respond /Manny create (.*) and (.*) under (.*)/i, (res) ->
#    itemType = 'backlog'
#    itemName1 = res.match[1]
#    itemName2 = res.match[2]
#    association = res.match[3]
#    assignedTo = ''
#    description = ''
#    status = ''
#    dataWrite = []
#    newData1 = 
#        name: itemName1
#        type: itemType
#        status: status
#        description: description
#        assignedto: assignedTo
#        association : [association]
#    newData2 =
#        name: itemName2
#        type: itemType
#        status: status
#        description: description
#        assignedto: assignedTo
#        association : [association]
#    items = [newData1, newData2]
#    
#    jsonfile.readFile JSONPATH, (error,data) ->
#        if error
#            console.log error
#            res.reply "Some thing wrong with data , let me come back"
#
#        if data and data.length > 0 
#           newData = [data..., items...]
#
#        else 
#            newData = items
#
#        jsonfile.writeFile JSONPATH, newData, {spaces:2}, (err) ->
#            if err
#                res.reply err 
#                return 
#    res.reply "#{itemName1} and #{itemName2} are created"   
# robot.respond /Manny create task with name (.*) , description (.*) in (.*) for (.*)/i, (res) ->
#    itemType = 'task'
#    itemName = res.match[1]
#    association = res.match[3]
#    assignedTo = res.match[4]
#    description = res.match[2]
#    status = 'New'
#    
#    newData = 
#        name: itemName
#        type: itemType
#        status: status
#        description: description
#        assignedto: assignedTo
#        association : [association]
#    
#    
#    jsonfile.readFile JSONPATH, (error,data) ->
#        if error
#            console.log error
#            res.reply "Some thing wrong with data , let me come back"
#        count = 0
#        availableBacklogs = []
#        if data and data.length > 0 
#           for member in data 
#                if member.name == association
#                    count++ 
#                if member.type == 'backlog'
#                    availableBacklogs.push member.name
#        if count>0
#            data.push newData
#        else 
#            backlogMessage = 'No backlog available'
#            if availableBacklogs.length > 0
#                 backlogMessages = "But available backlogs are " + availableBacklogs.join()
#            res.reply "Looks like there is no #{association} \n #{backlogMessages}"
#            return
#        jsonfile.writeFile JSONPATH, data, {spaces:2}, (err) ->
#            if err
#                res.reply err 
#                return 
#        res.reply "Task is created with name #{itemName}" 
# robot.respond /Manny move all tasks under (.*) to (.*)/i, (res) ->
#            
#            
# robot.respond /Manny list all tasks under (.*) backlog/i, (res) ->
#        backlogName = res.match[1]
#          
#        jsonfile.readFile JSONPATH, (error,data) ->
#            workitemsList = ''
#            dataBackup = data
#            for workitem in data
#                for task in dataBackup
#                    if workitem.name == backlogName and workitem.type == 'backlog' and workitem.name == task.association[0]
#                        workitemsList += 'Name - '+task.name+ ' Description -' + task.description+'\n'
#
#
#            if workitemsList ==  ''
#                res.reply "Looks like no backlog with name #{backlogName} as such..! \n or no task under #{backlogName}"
#            else 
#                res.reply "Here are the list of tasks under  #{backlogName} \n #{workitemsList}"
#        