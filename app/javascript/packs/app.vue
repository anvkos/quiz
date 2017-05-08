<template>
    <div class="container">
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <h2 class="text-center">{{ quiz.title}}</h2>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div v-if="mode == 'start'">
                    <div>
                        {{ quiz.description }}
                        <button class="btn btn-danger btn-block" @click="onStart()">Start quiz</button>
                    </div>
                </div>

                <div v-if="mode == 'question'">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title text-center">{{ question.body }}</h3>
                        </div>
                        <div class="panel-body">
                            <div v-for="answer in question.answers" :key='answer.id'>
                                <button class="btn btn-default btn-block" @click="onAnswer(answer)">{{ answer.body }}</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-if="mode == 'finish'">
                    <div>Your score {{ statGame.correctedAnswers }}</div>
                    <button class="btn btn-danger btn-block" @click="onStart()">Start quiz</button>
                </div>

            </div>
        </div>
    </div>
</template>

<script>

export default {
    props: ['quiz_data'],
    data: function () {
        console.log(this.quiz_data.questions)
        return {
            mode: 'start',
            quiz: this.quiz_data.quiz,
            questions: this.quiz_data.questions,
            question: {},
            statGame: {
                correctedAnswers: 0,
                currentQuestion: 0,
                countQuestions: 0
            }
        }
    },
    methods: {
        onStart: function() {
            this.resetStat()
            this.statGame.countQuestions = this.questions.length
            this.question = this.questions[this.statGame.currentQuestion]
            this.mode = 'question'
        },
        nextQuestion: function() {
            this.statGame.currentQuestion += 1
            if (this.statGame.currentQuestion == this.statGame.countQuestions) {
                this.mode = 'finish'
            } else {
                this.question = this.questions[this.statGame.currentQuestion]
            }
        },
        onAnswer: function(answer) {
            if (answer.correct) {
                this.statGame.correctedAnswers += 1
            } else {
                this.statGame.inCorrectedAnswers += 1
            }
            this.nextQuestion()
        },
        resetStat: function() {
            this.statGame.correctedAnswers = 0
            this.statGame.currentQuestion = 0
            this.statGame.countQuestions = 0
        }
    }
}
</script>

<style scoped>
h2 {
    text-transform: uppercase;
}
h2, div {
    text-align: center;
},
p {
    font-size: 2em;
    text-align: center;
}
</style>

