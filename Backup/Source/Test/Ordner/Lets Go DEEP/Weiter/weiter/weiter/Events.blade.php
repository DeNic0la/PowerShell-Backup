@extends('layouts.app')

@section('content')
<div class="container">
    <h1 class="display-4 font-weight-normal">MemoryVault</h1>


    <div class="row mb-2">

    
    @foreach($Events as $Event)
    <div class="col-md-4 pb-5">
      <div class="row no-gutters border rounded overflow-hidden flex-md-row h-100  mb-4 shadow-sm h-md-250 position-relative">
        <div class="col p-4 d-flex flex-column position-static">
          <strong class="d-inline-block mb-2 text-primary">{{$Event['Type']}}</strong>
          <h3 class="mb-0">{{$Event['Name']}}</h3>
          <div class="mb-1 text-muted">{{$Event['Date']}}</div>
          <p class="card-text mb-auto">{{$Event['Desc']}}</p>
          <a href="/event/{{$Event['id']}}" class="stretched-link">Go To Event</a>
        </div>
      </div>
    </div>
    @endforeach


  </div>
  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#CreateEvent">Event Erstellen</button>


<div class="modal fade" id="CreateEvent" tabindex="-1" role="dialog" aria-labelledby="CreateEventLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Event Erstellen</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form method="POST" action="/event/create" id="formCreateEvent">
        @csrf
            <div class="form-group">
                <label for="Name">Event Name</label>
                <input type="text" name="EventName" value="{{old('EventName')}}" class="form-control @error('EventName') is-invalid @enderror" id="Name">
                @error('EventName')
                  <div class="alert alert-danger">{{ $message }}</div>
                @enderror
            </div>
            <div class="form-group"> 
                <label for="Type">Event Type</label>
                <select id="Type" name="Type" value="{{old('Type')}}" class="form-control @error('Type') is-invalid @enderror">
                    <option value="WentOut">Ausgang</option>
                    <option value="Party">Geburi-Party</option>
                    <option value="Cup">CloseUp</option>
                </select>
                @error('Type')
                  <div class="alert alert-danger">{{ $message }}</div>
                @enderror
            </div>        
            <div class="form-group">
              <label for="startdate" class="col-form-label">Datum:</label>
              <input type="date" value="{{old('startdate')}}" class="form-control @error('startdate') is-invalid @enderror" name="startdate" id="startdate">
              @error('startdate')
                <div class="alert alert-danger">{{ $message }}</div>
              @enderror
            </div>
            <div class="form-group">
              <label for="enddate" class="col-form-label">Enddate:</label>
              <input type="date" value="{{old('enddate')}}" class="form-control @error('enddate') is-invalid @enderror" name="enddate" id="enddate">
              <small>Dieses Feld ist Optional</small>
              @error('enddate')
                <div class="alert alert-danger">{{ $message }}</div>
              @enderror
            </div>
            
            <div class="form-group">
          
              <label for="desc" class="col-form-label ">Beschreibung:</label>
              <textarea value="{{old('desc')}}" class="form-control @error('desc') is-invalid @enderror" name="desc" id="desc"></textarea>
              @error('desc')
                <div class="alert alert-danger">{{ $message }}</div>
              @enderror
            </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="submit" value="submit" form="formCreateEvent" class="btn btn-primary">Event Erstellen</button>
      </div>
    </div>
  </div>
</div>



</div>
@endsection
