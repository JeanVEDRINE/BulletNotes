{ Meteor } = require 'meteor/meteor'
{ check } = require 'meteor/check'
{ Match } = require 'meteor/check'
{ Notes } = require '../notes.coffee'

Meteor.publish 'notes.view', (noteId, shareKey = null) ->
  check noteId, Match.Maybe(String)
  check shareKey, Match.Maybe(String)
  if shareKey
    if Notes.getSharedParent noteId, shareKey
    # We have a valid shared parent key for this noteid and shareKey
    # Go ahead and return the requested note.
      return Notes.find _id:noteId 
  else
    note = Notes.find
      owner: @userId
      _id: noteId

Meteor.publish 'notes.children', (noteId, shareKey = null) ->
  check noteId, Match.Maybe(String)
  check shareKey, Match.Maybe(String)
  if shareKey
    note = Notes.findOne noteId
    # If we don't have a valid shared note, look at the parents, is one of them valid?
    if Notes.getSharedParent noteId, shareKey
      # One of the parents is validly shared, return the original note
      notes = Notes.find
        parent: noteId
  else
    notes = Notes.find
      owner: @userId
      parent: noteId

Meteor.publish 'notes.favorites', ->
  Notes.find
    owner: @userId
    favorite: true

Meteor.publish 'notes.search', (search) ->
  Notes.search search, this.userId