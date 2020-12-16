<template>
    <div class="container">
        <div class="row justify-content-center mb-r" ref="imageUpload">
            <div class="col-12 bg-dark text-white rounded py-3 my-2 text-center"> Dropzone</div>
        </div>
        
    </div>
</template>

<script>
    import Dropzone from 'dropzone';


    export default {
        data: function (){
            dropzone: null;
        },
        mounted() {
            this.dropzone = new Dropzone(this.$refs.imageUpload, {
                url: '/api/upload/' + window.eventId
            });
        }
    }
</script>
