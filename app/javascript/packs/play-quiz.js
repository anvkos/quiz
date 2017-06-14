/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'
import TurbolinksAdapter from 'vue-turbolinks';
import VueResource from 'vue-resource'

Vue.use(VueResource)

document.addEventListener('turbolinks:load', () => {
    Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    var element = document.getElementById("play-quiz")
    if (element != null) {
        var quiz = JSON.parse(element.dataset.quiz)
        var vm = new Vue({
            el: element,
            mixins: [TurbolinksAdapter],
            components: {
                'appQuiz': App
            },
            data: function() {
                return {
                    quiz: quiz
                }
            },
            methods: {
                quiz_data: function() {
                    return {
                        quiz: quiz
                    }
                }
            }
        });
    }
});
