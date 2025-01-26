<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Doctor;
use Illuminate\Support\Facades\Auth;
use App\Models\Appointments;
use App\Models\UserDetails;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use PhpParser\Node\Expr\Print_;

class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $user = array();
        $user = Auth::user();
        $doctor = User::where('type', 'doctor')->get();
        $details = $user->user_details;
        $doctorData = Doctor::all();
        $appointment = Appointments::where('status', 'proximo')
        ->where('user_id', $user->id)
        ->where('date', '>=', now()->format('n/j/Y'))
        ->orderBy('date', 'asc')
        ->first();
        foreach($doctorData as $data){
            foreach($doctor as $info){
                if($data['doc_id'] == $info['id']){
                    $data['doctor_name'] = $info['name'];
                    $data['doctor_profile'] = $info['profile_photo_url'];
                    if(isset($appointment) && $appointment['doc_id'] == $info['id']){
                        $data['appointments'] = $appointment;
                    }
                }
            }
        }

        $user['doctor'] = $doctorData;
        $user['details'] = $details;

        return $user;
    }

    /**
     * login
     */
    public function login(Request $reqeust)
    {
        $reqeust->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::where('email', $reqeust->email)->first();

        if(!$user || ! Hash::check($reqeust->password, $user->password)){
            throw ValidationException::withMessages([
                'email'=>['Las creedenciales proporcionadas son incorrectas'],
            ]);
        }

        return $user->createToken($reqeust->email)->plainTextToken;
    }

    /**
     * Registro
     */
    public function register(Request $request)
    {
        $request->validate([
            'name'=>'required|string',
            'email'=>'required|email',
            'password'=>'required',
        ]);

        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'user',
            'password'=>Hash::make($request->password),
        ]);

        $userInfo = UserDetails::create([
            'user_id'=>$user->id,
            'status'=>'active',
        ]);

        return $user;
    }


    /**
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function storeFavDoc(Request $request)
    {

        $saveFav = UserDetails::where('user_id',Auth::user()->id)->first();

        $docList = json_encode($request->get('favList'));

        $saveFav->fav = $docList;
        $saveFav->save();

        return response()->json([
            'success'=>'La lista de doctores favoritos se actualizó correctamente',
        ], 200);
    }

    /**
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function updateBioData(Request $request)
    {

        $userDetails = UserDetails::where('user_id',Auth::user()->id)->first();

        $userDetails->bio_data = $request->get('bio_data');

        $userDetails->save();

        return response()->json([
            'success'=>'La Bio Data se actualizó correctamente.',
        ], 200);
    }

    /**
     * logout.
     *
     * @return \Illuminate\Http\Response
     */
    public function logout(){
        $user = Auth::user();
        $user->currentAccessToken()->delete();

        return response()->json([
            'success'=>'Cierre de sesión exitosa!',
        ], 200);
    }


    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
