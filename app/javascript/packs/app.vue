<template>
    <div>
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <h2 class="text-center">{{ quiz.title}}</h2>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-8 col-md-offset-2">
                <div v-if="mode == 'start'" class="game-start">
                    <div>
                        <div>{{ quiz.description }}</div>
                        <div v-if="error" class="text-danger">
                            {{ error.message }}
                        </div>
                        <p>
                            <button class="btn btn-danger btn-block" @click="onStart()">Start quiz</button>
                        </p>
                        <div class="shared-links">
                        <button @click="onShareVK()" class='btn btn-primary'>VK</button>
                        <button @click="onShareOK()" class='btn btn-warning'>OK</button>
                        <button @click="onShareFB()" class='btn btn-default'><span class="text-info">FB</span></button>
                        <button @click="onShareTW()" class='btn btn-info'>TW</button>
                    </div>
                    </div>
                </div>

                <div v-if="mode == 'question'" class="game-question">
                    <div class="score pull-left text-success"> score: {{ score }} </div>
                    <div class="time pull-right text-warning"> time: {{ time_answer }} </div>
                    <div class="clearfix"></div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title text-center">{{ question.body }}</h3>
                        </div>
                        <div class="panel-body">
                            <ul class="list-group">
                              <li :class="['list-group-item', { correct: isCorrect[answer.id] }]" v-for="answer in question.answers" :key='answer.id'>
                                <label  :value="answered">
                                  <input type="checkbox" :value="answer.id" v-model="selectedAnswers" >
                                  {{ answer.body }}
                                </label>
                              </li>
                            </ul>
                            <button @click.prevent="onAnswer()" class="btn btn-success btn-block">Answer</button>
                        </div>
                    </div>
                </div>

                <div v-if="mode == 'finish'" class="game-finish">
                    <h2 class="score text-warning">Your score {{ score }}</h2>
                    <p>
                        <button class="btn btn-danger btn-block" @click="onStart()">Start quiz</button>
                    </p>
                    <div class="shared-links">
                        <button @click="onShareVK()" class='btn btn-primary'>VK</button>
                        <button @click="onShareOK()" class='btn btn-warning'>OK</button>
                        <button @click="onShareFB()" class='btn btn-default'><span class="text-info">FB</span></button>
                        <button @click="onShareTW()" class='btn btn-info'>TW</button>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>

<script>

export default {
    props: ['quiz_data'],
    data: function () {
        return {
            mode: 'start',
            quiz: this.quiz_data.quiz,
            question: {},
            score: 0,
            error: {},
            time_answer: this.quiz_data.quiz.time_answer,
            timerAnswer: null,
            answered: 0,
            selectedAnswers: [],
            isCorrect: [],
        }
    },
    computed: {
        linkText: function() {
            if ( this.mode == 'start') {
                return 'Prove your knowledge in the quiz ' + this.quiz.title
            }
            return 'I have ' + this.score + ' score in quiz ' + this.quiz.title
        },
        url: function() {
            return location.protocol + '//' + location.host + location.pathname;
        }
    },
    methods: {
        onStart: function() {
            this.resetStat()
            this.$http.post('/game/start', { quiz_id: this.quiz.id } )
                .then(response => {
                    this.question = {
                        body: response.data.body,
                        answers: response.data.answers
                    }
                    this.mode = 'question'
                    this.startAnswerTimer();
                }, response => {
                    this.error = {
                        error: response.data.error,
                        message: response.data.error_message
                    }
                })
        },
        onAnswer: function() {
            this.question.answers.map(answer => {
              if (answer.correct == true) {
                this.isCorrect[answer.id] = true;
              }
            });
            this.answered += 1;
            var answer_ids = this.selectedAnswers;
            this.selectedAnswers = [];
            this.$http.post('/game/check_answer', { answer_ids: answer_ids } )
                .then(response => {
                    var data = response.data
                    if (data.action != null && data.action == 'finish') {
                        this.score = data.score
                        this.mode = 'finish'
                        clearInterval(this.timerAnswer)
                    } else {
                        this.question = {
                            body: data.question.body,
                            answers: data.question.answers
                        }
                        this.score = data.score
                        this.resetTimerAnswer()
                    }
                }, response => {
                    console.log('error')
                    console.log(response)
                })
        },
        resetStat: function() {
            this.score = 0
            this.question = {}
            this.error = {}
            this.selectedAnswers = []
            this.isCorrect = []
        },
        startAnswerTimer: function() {
            this.time_answer = this.quiz_data.quiz.time_answer
            if (this.time_answer > 0) {
                this.timerAnswer = setInterval(() => {
                    this.time_answer = this.time_answer - 1
                    if (this.time_answer == 0) {
                        clearInterval(this.timerAnswer)
                    }
                }, 1000)
            }
        },
        resetTimerAnswer: function() {
            clearInterval(this.timerAnswer)
            this.time_answer = this.quiz_data.quiz.time_answer
            this.startAnswerTimer();
        },
        handleLinkClick: function(link) {
            window.open(link, '', 'width=640,height=480,top=' + ((screen.height - 480) / 2) + ',left=' + ((screen.width - 640) / 2))
        },
        onShareVK: function() {
          this.handleLinkClick('https://vk.com/share.php?url=' + this.url + '&description=' +this.linkText)
        },
        onShareTW: function() {
          this.handleLinkClick('https://twitter.com/intent/tweet?url=' + this.url+ '&text=' + this.linkText)
        },
        onShareFB: function() {
          this.handleLinkClick('https://www.facebook.com/sharer.php?src=sp&u=' + this.url)
        },
        onShareOK: function() {
          this.handleLinkClick('https://connect.ok.ru/dk?st.cmd=WidgetSharePreview&st.shareUrl=' + this.url)
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
.correct {
    background-color: green;
}
</style>

