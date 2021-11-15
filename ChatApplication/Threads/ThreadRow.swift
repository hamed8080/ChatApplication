//
//  ThreadRow.swift
//  ChatApplication
//
//  Created by Hamed Hosseini on 5/27/21.
//

import SwiftUI
import FanapPodChatSDK

struct ThreadRow: View {
	
	var thread:Conversation
	@State private (set) var showActionSheet:Bool = false
	@State private (set) var showParticipants:Bool = false
	
    @StateObject
    var viewModel:ThreadsViewModel
    
    @EnvironmentObject
    var appState:AppState
    
    @State
    var isTypingText:String? = nil
	
	var body: some View {
		
		Button(action: {}, label: {
			HStack{
                Avatar(url:thread.image ,userName: thread.inviter?.username?.uppercased(), fileMetaData: thread.metadata)
				VStack(alignment: .leading, spacing:8){
					Text(thread.title ?? "")
						.font(.headline)
					if let message = thread.lastMessageVO?.message?.prefix(100){
						Text(message)
							.lineLimit(1)
							.font(.subheadline)
					}
                    if viewModel.model.threadsTyping.contains(where: {$0.threadId == thread.id }){
                        Text(isTypingText ?? "")
                            .frame(width: 72, alignment: .leading)
                            .lineLimit(1)
                            .font(.subheadline.bold())
                            .foregroundColor(Color.orange)
                            .onAppear{
                                "typing".isTypingAnimationWithText { startText in
                                    self.isTypingText = startText
                                } onChangeText: { text in
                                    self.isTypingText = text
                                } onEnd: {
                                    self.isTypingText = nil
                                }
                            }
                    }
				}
				Spacer()
				if thread.pin == true{
					Image(systemName: "pin.fill")
						.foregroundColor(Color.orange)
				}
				if let unreadCount = thread.unreadCount ,let unreadCountString = String(unreadCount){
					let isCircle = unreadCount < 10 // two number and More require oval shape
					let computedString = unreadCount < 1000 ? unreadCountString : "\(unreadCount / 1000)K+"
					Text(computedString)
						.font(.system(size: 13))
						.padding(8)
						.frame(height: 24)
						.frame(minWidth:24)
						.foregroundColor(Color.white)
						.background(Color.orange)
						.cornerRadius(isCircle ? 16 : 8, antialiased: true)
				}
			}
			.contentShape(Rectangle())
			.padding([.leading , .trailing] , 8)
			.padding([.top , .bottom] , 4)
		})
		.onTapGesture {
            appState.showThread = false
            appState.selectedThread = thread
		}.onLongPressGesture {
			showActionSheet.toggle()
		}
		.actionSheet(isPresented: $showActionSheet){
			ActionSheet(title: Text("Manage Thread"), message: Text("you can mange thread here"), buttons: [
				.cancel(Text("Cancel").foregroundColor(Color.red)),
							.default(Text((thread.pin ?? false) ? "UnPin" : "Pin")){
					viewModel.pinUnpinThread(thread)
				},
				.default(Text( (thread.mute ?? false) ? "Unmute" : "Mute" )){
					viewModel.muteUnMuteThread(thread)
				},
                .default(Text("Clear History")){
                    viewModel.clearHistory(thread)
                },
				.default(Text("Delete")){
                    withAnimation {
                        viewModel.deleteThread(thread)
                    }
				}
			])
        }
        .onLongPressGesture {
            showActionSheet.toggle()
        }
	}
}

struct ThreadRow_Previews: PreviewProvider {
	static var thread:Conversation{
        
		let lastMessageVO = Message(threadId: nil, deletable: nil, delivered: nil, editable: nil, edited: nil, id: nil, mentioned: nil, message: "Hi hamed how are you? are you ok? and what are you ding now. And i was thinking you are sad for my behavoi last night.", messageType: nil, metadata: nil, ownerId: nil, pinned: nil, previousId: nil, seen: nil, systemMetadata: nil, time: nil, timeNanos: nil, uniqueId: nil, conversation: nil, forwardInfo: nil, participant: nil, replyInfo: nil)
		let thread = Conversation(admin: false, canEditInfo: true, canSpam: true, closedThread: false, description: "des", group: true, id: 123, image: "http://www.careerbased.com/themes/comb/img/avatar/default-avatar-male_14.png", joinDate: nil, lastMessage: nil, lastParticipantImage: nil, lastParticipantName: nil, lastSeenMessageId: nil, lastSeenMessageNanos: nil, lastSeenMessageTime: nil, mentioned: nil, metadata: nil, mute: nil, participantCount: nil, partner: nil, partnerLastDeliveredMessageId: nil, partnerLastDeliveredMessageNanos: nil, partnerLastDeliveredMessageTime: nil, partnerLastSeenMessageId: nil, partnerLastSeenMessageNanos: nil, partnerLastSeenMessageTime: nil, pin: false, time: nil, title: "Hamed Hosseini", type: nil, unreadCount: 3000, uniqueName: nil, userGroupHash: nil, inviter: nil, lastMessageVO: lastMessageVO, participants: nil, pinMessage: nil)
		return thread
	}
	
	static var previews: some View {
		ThreadRow(thread: thread,viewModel: ThreadsViewModel())
	}
}
