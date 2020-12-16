<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App;
use Illuminate\Support\Str;

class EventsController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth');
    }

    public function index(){

        $data  = App\Event::all();
        
        foreach($data as $dat){
            
            $dat['Desc'] = str::limit($dat['Desc'], 200, ' ...');
            //dd($dat);
        }
        //dd($data);
         
        return view('Events',['Events' => $data]);
    }

    public function create(Request $request){
        //dd($request);
        $validated = $request->validate([
            "EventName" => "required|unique:Events,Name",
            "Type" => "required|in:WentOut,Party,Cup",
            "startdate" => "required|date",
            "enddate" => "",
            "desc" => "required"
        ]);
        App\Event::create([
            'Name' => $validated['EventName'],
            'Type' => $validated['Type'],
            'Date' => $validated['startdate'],
            'EndDate' => $validated['enddate'],
            'Desc' => $validated['desc'],
        ]);
        return redirect('/event');
    }
    public function show($id) { 

        //dd(App\Event::findorfail($id));  
        $Event = App\Event::findorfail($id);
        if ($Event == null){
            abort(404, "This Event is Kinda not there");
        }
        $Images = $Event->images()->get();
        return view('Event',[
            'Event' => $Event,
            'Images' => $Images,
        ]);
    }
}
