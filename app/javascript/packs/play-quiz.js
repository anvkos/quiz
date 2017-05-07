/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %>
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

import Vue from 'vue/dist/vue.esm'
import App from './app.vue'

document.addEventListener('DOMContentLoaded', () => {
    document.body.appendChild(document.createElement('play-quiz'))
    var element = document.getElementById("play-quiz")

    var quiz = JSON.parse(element.dataset.quiz)
    var questions = JSON.parse(element.dataset.questions)

    if (element != null) {

        var vm = new Vue({
            el: element,
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
                        quiz: quiz,
                        questions: questions
                    }
                }
            }
        })
    }
})
