import * as functions from "firebase-functions"
import * as admin from "firebase-admin"
admin.initializeApp()

const db = admin.firestore()

export const messageNotification2 = functions.firestore.document("ChatCenter/{chatRoomUID}/MessageContain/{id}").onCreate(async (snapshot, context) => {
    // const id = context.params.id
    // const chatRoomUID = context.params.chatRoomUID

    // const senderUID = snapshot.data().senderDocID
    const contactWith = snapshot.data().contactWith
    const text = snapshot.data().text as string

    return db.collection("ChatUserUIDSet").where("chatDocId", "==", contactWith)
    .get()
    .then(value => {
        value.forEach(result => {
            const  token = result.data().userToken as string
            // console.log(`presenting data chatRoomUID: ${chatRoomUID}, id: ${id}, senderUID: ${senderUID}, token: ${token}`)
            // return result.data().userToken

            const payload = {
                notification: {
                    title: "New message",
                    body: text
                }
            }
            // return admin.messaging().sendToDevice(token, payload)
            return admin.messaging().sendToDevice(token, payload)
        })
    })
    .catch(err => {
        console.log(err)
        return null
    })   
})


