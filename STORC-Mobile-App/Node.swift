//
//  Node.swift
//  STORC-Mobile-App
//
//  Created by Brian H on 7/10/23.
//

import Foundation
import UIKit

class Node<T>{
    
    var value: T
    var next: Node<T>?
    
    init(value: T, next: Node<T>? = nil){
        self.value = value
        self.next = next
    }
}

struct LinkedList<T>{
    var head: Node<T>?
    var tail: Node<T>?
    
    var isEmpty: Bool{
        head == nil
    }
    
    init(){}
    
    //add a value to the start of the list
    mutating func push(_ value: T){
        head = Node(value: value, next: head)
        
        if(tail == nil){
            tail = head
        }
    }
    
    //append a value to the end of the list
    mutating func append(_ value: T){
        let node = Node(value: value)
        
        tail?.next = node
        tail = node
    }
    
    //get the node at the index
    func getNodeAt(at index: Int) -> Node<T>? {
        var current = 0
        var currentNode = head
        
        while(currentNode != nil && current < index) {
            currentNode = currentNode?.next
            current = current + 1
        }
        
        return currentNode
    }
    
    //remove head from list and return new head value
    mutating func pop() -> T? {
        defer {
            head = head?.next
            
            if(isEmpty){
                tail = nil
            }
        }
        
        return head?.value
    }
    
    //remove tail from list and return new tail value
    mutating func removeLast() -> T? {
        //handle case where list is empty
        guard let head = head else { return nil }
        //handle case where the head is only value
        if(head.next == nil){
            return pop()
        }
        
        var previousNode = head
        var currentNode = head
        
        while let next = currentNode.next {
            previousNode = currentNode
            currentNode = next
        }
        
        previousNode.next = nil
        tail = previousNode
        
        return currentNode.value
    }
}
