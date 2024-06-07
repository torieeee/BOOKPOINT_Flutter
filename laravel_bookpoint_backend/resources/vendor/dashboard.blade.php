<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    {{ $appointements }}

    <div class="min-h-screem py-12">
        <div class ="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-center bg-gray-100 py-10 p-14">
                <!-- First Stats Container -->
                <div class="container mx-auto pr-4">
                    <div
                        class="w-72 bg-white max-w-xs rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">UPCOMING APPOINTMENTS</p>
                        </div>
                        <div class="flex-justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">20</p>
                    </div>
                </div>

                <!-- Second Stats Container -->
                <div class="container mx-auto pr-4">
                    <div
                        class="w-72 bg-white max-w-xs rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">PATIENTS</p>
                        </div>
                        <div class="flex-justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">20</p>
                    </div>
                </div>

                 <!-- Third Stats Container -->
                 <div class="container mx-auto pr-4">
                    <div
                        class="w-72 bg-white max-w-xs rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">RATINGS</p>
                        </div>
                        <div class="flex-justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">20</p>
                    </div>
                </div>

                 <!-- Fourth Stats Container -->
                 <div class="container mx-auto pr-4">
                    <div
                        class="w-72 bg-white max-w-xs rounded-sm overflow-hidden shadow-lg hover:shadow-2xl transition duration-500 transform hover:scale-100 cursor-pointer">
                        <div class="h-20 bg-blue-500 flex items-center justify-between">
                            <p class="mr-0 text-white text-lg pl-5">REVIEWS</p>
                        </div>
                        <div class="flex-justify-between px-5 pt-6 mb-2 text-sm text-gray-600">
                            <p>TOTAL</p>
                        </div>
                        <p class="py-4 text-3xl ml-5">20</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>
