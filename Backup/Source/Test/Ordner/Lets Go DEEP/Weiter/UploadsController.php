<?php

namespace App\Http\Controllers;

use App;
use App\Event;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
use Illuminate\Support\Str;
use Intervention\Image\Facades\Image;


class UploadsController extends Controller
{
    public function store($EventId){
        
        $Event = Event::findorfail($EventId);
        $dirName = $Event['Name'];
        if (! is_dir(public_path('/images'))){
            mkdir(public_path('/images'), 0777);
        }
        if (! is_dir(public_path('/images/' . $dirName ))){
            mkdir(public_path('/images/' . $dirName ), 0777);
        }
        $images = Collection::wrap(request()->file('file'));
        $images->each(function ($image) use($dirName, $Event) {
            $basename = Str::random();
            $original = $basename.'.'. $image->getClientOriginalExtension();  
            $thumbnail = $basename.'_thumb.'. $image->getClientOriginalExtension();
            
            Image::make($image)->fit(250,250)->save(public_path('/images/' . $dirName.'/'.$thumbnail));

            $image->move(public_path('/images/' . $dirName), $original);
            $Event->images()->create([
                'original' =>  '/images/'.$dirName.'/'.$original,
               'thumbnail' => '/images/'.$dirName.'/'.$thumbnail,
            ]);            
        });

    }

    public function Upload(request $request, $EventId){
        
        //dd($request->hasFile('image'));
        $files[] = $request->file('image');
        if ($files == null)
            return redirect('/event/'.$EventId);
        dd($request);

        $Event = Event::findorfail($EventId);
        $dirName = $Event['Name'];
        if (! is_dir(public_path('/images'))){
            mkdir(public_path('/images'), 0777);
        }
        if (! is_dir(public_path('/images/' . $dirName ))){
            mkdir(public_path('/images/' . $dirName ), 0777);
        }
        $images = Collection::wrap($files);
        $images->each(function ($image) use($dirName, $Event) {
            $basename = Str::random();
            $original = $basename.'.'. $image->getClientOriginalExtension();  
            $thumbnail = $basename.'_thumb.'. $image->getClientOriginalExtension();
            
            Image::make($image)->fit(250,250)->save(public_path('/images/' . $dirName.'/'.$thumbnail));

            $image->move(public_path('/images/' . $dirName), $original);
            $Event->images()->create([
                'original' =>  '/images/'.$dirName.'/'.$original,
               'thumbnail' => '/images/'.$dirName.'/'.$thumbnail,
            ]);            
        });
        
        

    }
}
