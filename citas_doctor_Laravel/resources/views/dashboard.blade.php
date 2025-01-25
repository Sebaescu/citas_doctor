<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>
    <div class="min-h-screen py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-center bg-gray-100 py-10 p-14">
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-black flex items-center justify-between">
                            <p class="mr-0 text-white font-semibold text-lg pl-5">PRÓXIMAS CITAS</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{ count($appointments) }}</p>
                    </div>
                </div>
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-black flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">PACIENTES</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{ $doctor->doctor['patients'] ?? 0 }}</p>
                    </div>
                </div>
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-black flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">RATING</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">
                            @if(isset($reviews))
                                @php
                                    $count = count($reviews);
                                    $rating = 0;
                                    $total = 0;

                                    if($count != 0){
                                        foreach ($reviews as $review) {
                                            $total += $review['ratings'];
                                        }
                                        $rating = $total / $count;
                                    }else{
                                        $rating = 0;
                                    }
                                @endphp
                            @endif
                            {{ $rating }}
                        </p>
                    </div>
                </div>
                <div class="container mx-auto pr-4">
                    <div class="w-72 bg-white max-w-xs mx-auto rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-black flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">RESEÑAS</p>
                        </div>
                        <div class="flex justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">{{ count($reviews) }}</p>
                    </div>
                </div>
            </div>
            <div class="bg-white overflow-hidden shadow-xl sm:rounded-lg">
                <div class="row">
                    <div class="col-md-7 mt-4">
                        <div class="card">
                            <div class="card-header my-3 pb-0 px-3">
                                <h6 class="mb-0">Ultimas Reseñas</h6>
                            </div>
                            <div class="card-body pt-4 p-3">
                                @if(isset($reviews) && !$reviews->isEmpty())
                                    <ul class="list-group">
                                        @foreach ($reviews as $review)
                                            @if(isset($review->reviews) && $review->reviews != '')
                                                <li class="list-group-item border-0 d-flex p-4 mb-2 bg-gray-100 border-radius-lg">
                                                    <div class="d-flex flex-column">
                                                        <h6 class="mb-3 text-sm">{{ $review->reviewed_by }}</h6>
                                                        <div class="flex justify-between">
                                                            <span class="mb-2 text-xs">{{ $review->reviews ?? '-' }}</span>
                                                            <span class="mb-2 text-xs">{{ $review->created_at ?? '-' }}</span>
                                                        </div>
                                                    </div>
                                                </li>
                                            @endif

                                        @endforeach
                                    </ul>
                                @else
                                    <div class="border-0 d-flex p-4 mb-2 mt-3 bg-gray-100 border-radius-lg">
                                        <h6 class="mb-3 text-sm">No hay Reseñas todavia!</h6>
                                    </div>
                                @endif
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
