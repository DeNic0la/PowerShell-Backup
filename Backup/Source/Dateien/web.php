<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::get('/event','EventsController@index');
Route::post('/event/create', 'EventsController@create');
Route::get('/event/{id}','EventsController@show');
Route::post('/upload/{EventId}', 'UploadsController@Upload');


Route::get('/images/{imagepath}/{imagename}.{tes}', function () { return redirect('/'); }); // This is working but has not enough Prio
Auth::routes();

