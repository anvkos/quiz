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
                    <div> score: {{ score }} </div>
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
                    <div>Your score {{ score }}</div>
                    <button class="btn btn-danger btn-block" @click="onStart()">Start quiz</button>
                    <div class="shared-links">
                        <button @click="onShareVK()">VK</button>
                        <button @click="onShareOK()">OK</button>
                        <button @click="onShareFB()">FB</button>
                        <button @click="onShareTW()">TW</button>
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
            score: 0
        }
    },
    computed: {
        linkText: function() {
            return 'I have ' + this.score + ' score in quiz ' + this.quiz.title
        },
        url: function() {
            return window.top.location.href
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
                }, response => {
                    console.log('error')
                    console.log(response)
                })
            this.mode = 'question'
        },
        onAnswer: function(answer) {
            if (answer.correct) {
                this.score += 1
            }
            this.$http.post('/game/check_answer', { answer_id: answer.id } )
                .then(response => {
                    var data = response.data
                    if (data.action != null && data.action == 'finish') {
                        this.score = data.score
                        this.mode = 'finish'
                    } else {
                        this.question = {
                            body: data.body,
                            answers: data.answers
                        }
                    }
                }, response => {
                    console.log('error')
                    console.log(response)
                })
        },
        resetStat: function() {
            this.score = 0
            this.question = {}
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
</style>

