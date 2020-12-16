@extends('layouts.app')

@section('content')
<div class="position-relative overflow-hidden p-3 p-md-5 text-center bg-light">
  <div class="col-md-5 p-lg-5 mx-auto my-5">
    <h1 class="display-4 font-weight-normal">{{$Event['Name']}}</h1>
    <p class="lead font-weight-normal">{{$Event['Desc']}}</p>
  </div>
  <div class="product-device shadow-sm d-none d-md-block"></div>
  <div class="product-device product-device-2 shadow-sm d-none d-md-block"></div>
</div>
<div class="" id="app">
  <script>
    window.eventId = "{{ $Event['id'] ?? '' }}"
  </script>
  <dropzone></dropzone>

 


    <form action="/upload/{{ $Event['id'] }}" method="POST" enctype="multipart/form-data">
      @csrf

          <input type="file" name="image" id="image[]" multiple accept='image/*'>     
          <button class="btn btn-outline-secondary" type="submit" id="button-addon2">Hochladen</button>

    </form>



</div>


<div class="container">
  <div class="row">
    @foreach ($Images as $image)
        <div class="col-2 mb-4">
          <a href="{{$image->original}}">
            <img src="{{$image->thumbnail}}" alt="Picture from Event" class="w-100">
          </a>
        </div>
    @endforeach
  </div>
</div>

@endsection
